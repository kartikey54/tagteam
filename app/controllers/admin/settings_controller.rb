# frozen_string_literal: true

module Admin
  # Controller for admins to update/change settings
  class SettingsController < ApplicationController
    before_action :find_setting, only: :update

    def new
      authorize :admin_setting, :new?
      breadcrumbs.add 'Admin Setting', new_admin_setting_path

      @setting = Admin::Setting.first_or_initialize
    end

    def create
      authorize :admin_setting, :create?

      @setting = Admin::Setting.new(settings_params)

      if @setting.save
        redirect_to new_admin_setting_path, notice: 'Setting was created sucessfully'
      else
        render :index
      end
    end

    def update
      authorize :admin_setting, :update?

      if @setting.update(settings_params)
        redirect_to new_admin_setting_path, notice: 'Setting was updated sucessfully'
      else
        render :index
      end
    end

    private

    def settings_params
      settings_parameters = params.require(:admin_setting).permit(:signup_description)

      settings_parameters[:whitelisted_domains] = domain_params(:whitelisted_domains)
      settings_parameters[:blacklisted_domains] = domain_params(:blacklisted_domains)

      settings_parameters
    end

    def find_setting
      @setting = Admin::Setting.find_by(id: params[:id])

      return if @setting.present?

      flash[:error] = 'Something went wrong, try again.'
      redirect_to new_admin_setting_path
    end

    def domain_params(parameters)
      return [] if params[:admin_setting][parameters].blank?

      params[:admin_setting][parameters].split(',').collect(&:strip)
    end
  end
end
