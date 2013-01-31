module ApplicationHelper

  def link_to_submit(text, html_class)
    link_to_function text, "$(this).closest('form').submit()", :class => html_class
  end

end
