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
      
      # Activities Singulares solo mostrar la mas reciente por usuario [ids = 000]
      singles = Activity
        .where(
          "id IN (
            SELECT id
            FROM (
              SELECT publisher_id, MONTH(created_at) as mes, ( WEEK(created_at,5) - WEEK(DATE_SUB(created_at, INTERVAL DAYOFMONTH(created_at)-1 DAY),5)+1 ) as semana,
                MAX(id) as id
              FROM `activities`
              WHERE publisher_id IN (?) AND act_type = '000'
              GROUP BY publisher_id, mes, semana
            ) as d
          )", ids)
        .order("created_at desc")
        .limit(50)
      
      # Activities grupales
      # 1. Relationship: Caso followed (Si sigo a los dos solo debería mostrar la notificación de uno)
      followed = Activity.find_by_sql( ["
        SELECT a.*, d.users
        FROM (
          SELECT publisher_id, MONTH(created_at) as mes, ( WEEK(created_at,5) - WEEK(DATE_SUB(created_at, INTERVAL DAYOFMONTH(created_at)-1 DAY),5)+1 ) as semana,
            MAX(id) as id, GROUP_CONCAT(user_id) as users
          FROM `activities`
          WHERE publisher_id IN (?) AND act_type = '010'
          GROUP BY publisher_id, mes, semana
        ) as d, activities a
        WHERE d.id = a.id
        ORDER BY created_at desc", ids] )
      
      
      # 2. Fotos y videos (p.e. Usuario publicó 2 fotos nuevas)
      
      # 3. Join events (p.e. Si sigo a varios que se unieron a un mismo evento)
      
      # Activities únicas siempre se muestran (p.e. Posts, eventos, Recommend y Certified) [ids = 001, 002, 003, 004, 031, 032, 033, 100, 101, 102, 202]
      uniques = Activity.all(:conditions => ["publisher_id IN (?) AND act_type IN ('001', '002', '003', '004', '031', '032', '033', '100', '101', '102', '202')", ids], :order => "created_at desc", :limit => 50)
      
      @news = ( singles + followed + uniques ).sort_by(&:created_at).reverse
      # master
      # @news = Activity.all(:conditions => ["publisher_id IN (?)", ids], :order => "created_at desc").paginate(:page => params[:page], :per_page => 15)
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_url
    end
  end
  
end
