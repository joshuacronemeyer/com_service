require_relative 'sendgrid_gateway'
require_relative 'postmark_gateway'

class EmailProvider
  EMAIL_SERVICES = ["sendgrid", "postmark"]

  def send_email(email:, logger: nil)
    configured_service = ENV["EMAIL_SERVICE"]

    raise "Email service must be sendgrid or postmark" if configured_service.nil? || !EMAIL_SERVICES.include?(configured_service.downcase)
    if configured_service.downcase == "sendgrid"
      logger.info "Using sendgrid" if logger
      SendgridGateway.new.send_email(email: email)
    elsif configured_service.downcase == "postmark"
      logger.info "Using postmark" if logger
      PostmarkGateway.new.send_email(email: email)
    end
  end
end
