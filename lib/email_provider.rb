# frozen_string_literal: true

require_relative 'sendgrid_gateway'
require_relative 'postmark_gateway'

# Understands what email provider to delegate to
class EmailProvider
  EMAIL_SERVICES = %w[sendgrid postmark].freeze

  def send_email(email:, logger: nil)
    configured_service = ensure_configured_service
    case configured_service.downcase
    when 'sendgrid'
      logger&.info 'Using sendgrid'
      SendgridGateway.new.send_email(email: email)
    when 'postmark'
      logger&.info 'Using postmark'
      PostmarkGateway.new.send_email(email: email)
    end
  end

  private

  def ensure_configured_service
    configured_service = ENV['EMAIL_SERVICE']
    if configured_service.nil? || !EMAIL_SERVICES.include?(configured_service.downcase)
      raise 'Email service must be sendgrid or postmark'
    end

    configured_service
  end
end
