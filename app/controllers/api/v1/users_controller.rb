# frozen_string_literal: true

require 'json_web_token'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: :login
      before_action :authenticate_request, only: %i[index me create]
      before_action :authorize_user, only: %i[index me create]

      def index
        @users = User.kept
        render json: UserSerializer.new(@users).serializable_hash.to_json
      end

      def me
        render json: UserSerializer.new(@current_user).serializable_hash, status: :ok
      end

      def create
        @user = User.new(user_params)
        @user.role = Role.find(params[:user][:role_id])
        if @user.save
          token = JsonWebToken.encode(user_id: @user.id)
          render json: {
            user: UserSerializer.new(@user).serializable_hash,
            token: token
          }, status: :created
        else
          render_error
        end
      end

      def login
        if @user.authenticate(params[:user][:password])
          token = JsonWebToken.encode(user_id: @user.id)
          render json: { token: token,
                         exp: 1.minute.after(Time.zone.now).strftime('%m-%d-%Y %H:%M'),
                         username: @user.first_name }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def set_user
        @user = User.find_by!(email: params[:user][:email])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :photo)
      end

      def render_error
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end
end
