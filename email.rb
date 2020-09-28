class Email
  def initialize(to:, to_name:, from:, from_name:, subject:, body:)
    @to = to
    @to_name = to_name
    @from = from
    @from_name = from_name
    @subject = subject
    @body = body
  end

  def valid?
    return !@to.nil? && @to != ''
  end
end
