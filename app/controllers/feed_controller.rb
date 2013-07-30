class FeedController < ApplicationController
  require 'will_paginate/array'
  def index
    if signed_in?
      # Si viene con un redirect
      if session[:redirected_by] && session[:redirected_by] != ""
        tmp = session[:redirected_by]
        session[:redirected_by] = nil
        redirect_to tmp and return
      end
      
      publishers_ids = Subscription.joins(:publisher => :user).where("subscriptions.user_id = ? AND users.authentic_email = 1", current_user.id).collect(&:publisher_id)
      others_ids = Subscription.joins(:publisher).where("subscriptions.user_id = ? AND publishers.user_id IS NULL", current_user.id).collect(&:publisher_id)
      ids = publishers_ids + others_ids
      
      # Obtener los ids de las noticias, ya que si lo  hacemos individual para cada caso puede traer noticias de fechas en distinto orden.
      ids_news = Activity.select("id").where(["publisher_id IN (?)", ids]).order("created_at DESC").paginate(:page => params[:page], :per_page => 50)
      
      if ids_news.count > 0
        # Activities Singulares solo mostrar la mas reciente por usuario [ids = 000]
        singles = Activity.where(
            "id IN (
              SELECT id
              FROM (
                SELECT publisher_id, YEAR(created_at) as anio, MONTH(created_at) as mes, ( WEEK(created_at,5) - WEEK(DATE_SUB(created_at, INTERVAL DAYOFMONTH(created_at)-1 DAY),5)+1 ) as semana,
                  MAX(id) as id
                FROM `activities`
                WHERE id IN (?) AND act_type = '000'
                GROUP BY publisher_id, anio, mes, semana
              ) as d
            )", ids_news ).order("created_at ASC")
        
        # Activities grupales
        # 1. Relationship: Caso followed (Agrupa por semana)
        followed = Activity.find_by_sql( ["
          SELECT a.*, d.users
          FROM (
            SELECT publisher_id, YEAR(created_at) as anio, MONTH(created_at) as mes, ( WEEK(created_at,5) - WEEK(DATE_SUB(created_at, INTERVAL DAYOFMONTH(created_at)-1 DAY),5)+1 ) as semana,
              MAX(id) as id, GROUP_CONCAT(user_id) as users
            FROM `activities`
            WHERE id IN (?) AND act_type = '010'
            GROUP BY publisher_id, anio, mes, semana
          ) as d, activities a
          WHERE d.id = a.id
          ORDER BY created_at ASC", ids_news] )
        
        # 2. Relationship: Caso followers (Agrupa por semanas)
        followers = Activity.find_by_sql( ["
          SELECT a.*, d.followers
          FROM (
            SELECT publisher_id, YEAR(created_at) as anio, MONTH(created_at) as mes, ( WEEK(created_at,5) - WEEK(DATE_SUB(created_at, INTERVAL DAYOFMONTH(created_at)-1 DAY),5)+1 ) as semana,
              MAX(id) as id, COUNT(1) as followers
            FROM `activities`
            WHERE id IN (?) AND act_type = '011'
            GROUP BY publisher_id, anio, mes, semana
          ) as d, activities a
          WHERE d.id = a.id
          ORDER BY created_at ASC", ids_news] )
        
        # 2. Fotos y videos (p.e. Usuario publicó 2 fotos nuevas) [ids = 020, 021]
        # Hay que hacer la vista grupal de fotos y videos
        
        # 3. Join events (p.e. Si sigo a varios que se unieron a un mismo evento) [ids = 030]
        joined = Activity.find_by_sql( ["
          SELECT a.*, d.users
          FROM (
            SELECT a.event_id, YEAR(a.created_at) as anio, MONTH(a.created_at) as mes, ( WEEK(a.created_at,5) - WEEK(DATE_SUB(a.created_at, INTERVAL DAYOFMONTH(a.created_at)-1 DAY),5)+1 ) as semana,
              MAX(a.id) as id, GROUP_CONCAT(p.user_id) as users
            FROM `activities` a, `publishers` p
            WHERE a.id IN (?) AND a.act_type = '030' AND a.publisher_id = p.id
            GROUP BY event_id, anio, mes, semana
          ) as d, activities a
          WHERE d.id = a.id
          ORDER BY created_at ASC", ids_news])
        
        # Activities únicas siempre se muestran (p.e. Posts, eventos, Recommend y Certified) [ids = 001, 002, 003, 004, 031, 032, 033, 100, 101, 102, 202, 020, 021] 
        uniques = Activity.where( [ "id IN (?) AND act_type IN ('001', '002', '003', '004', '031', '032', '033', '100', '101', '102', '202', '020', '021')", ids_news ] ).order("created_at ASC")
      end
      
      @news = ( singles + followed + followers + joined + uniques ).sort_by(&:created_at).reverse
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_url
    end
  end
  
end
