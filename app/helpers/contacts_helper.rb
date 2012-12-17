module ContactsHelper

  def formatted_contact_name(contact, highlight_class=nil)
    span_class = highlight_class || "highlight"
    html = ""
    if !contact.last_name.blank? && !contact.first_name.blank?
      html = "#{contact.first_name} #{highlight(contact.last_name, span_class)}"
    elsif !contact.last_name.blank?
      html = highlight(contact.last_name, span_class)
    elsif !contact.first_name.blank?
      html = highlight(contact.first_name, span_class)
    else
      html = highlight(contact.full_name, span_class)
    end
    html.html_safe
  end
  
  def highlight(content, css_class)
    content_tag(:span, content, :class => css_class)
  end
  
  def selected_contact(contact, selected)
    selected == contact ? "selected" : ""
  end
end
