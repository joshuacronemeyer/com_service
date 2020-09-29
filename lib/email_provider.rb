# frozen_string_literal: true

require_relative 'sendgrid_gateway'
require_relative 'postmark_gateway'

class EmailProvider
  EMAIL_SERVICES = %w[sendgrid postmark].freeze

  def send_email(email:, logger: nil)
    configured_service = ENV['EMAIL_SERVICE']

    if configured_service.nil? || !EMAIL_SERVICES.include?(configured_service.downcase)
      raise 'Email service must be sendgrid or postmark'
    end

    if configured_service.downcase == 'sendgrid'
      logger&.info 'Using sendgrid'
      SendgridGateway.new.send_email(email: email)
    elsif configured_service.downcase == 'postmark'
      logger&.info 'Using postmark'
      PostmarkGateway.new.send_email(email: email)
    end
  end
end
