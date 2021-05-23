class Form
  attr_reader :form_errors

  def initialize(errors)
    @form_errors = errors
  end
end
