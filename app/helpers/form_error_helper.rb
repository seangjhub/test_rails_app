module FormErrorHelper

  def display_error(field)
    errors = @form&.form_errors
    if errors.present? && errors.key?(field).present?
      "<small class='invalid-feedback'> #{errors[field]} </small>".html_safe
    end
  end

end
