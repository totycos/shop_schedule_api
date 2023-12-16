# frozen_string_literal: true

module Api
  module V1
    # Controller responsible for handling API requests related to schedules.
    class SchedulesController < ApplicationController
      before_action :set_api_v1_shop_schedule, only: %i[show update destroy]

      # GET /api/v1/shops/1/schedules
      def index
        @api_v1_shop_schedules = Schedule.where(shop_id: params[:shop_id])
        render json: @api_v1_shop_schedules
      end

      # GET /api/v1/shops/1/schedules/1
      def show
        render json: @api_v1_shop_schedule
      end

      # POST /api/v1/shops/1/schedules
      def create
        @shop = Shop.find(params[:shop_id])
        @api_v1_shop_schedule = @shop.schedules.create!(api_v1_shop_schedule_params)
        render json: @api_v1_shop_schedule, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      # PATCH/PUT /api/v1/shops/1/schedules/1
      def update
        @shop = Shop.find(params[:shop_id])
        @api_v1_shop_schedule = @shop.schedules.find(params[:id])

        @api_v1_shop_schedule.update!(api_v1_shop_schedule_params)
        render json: @api_v1_shop_schedule
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      # DELETE /api/v1/shops/1/schedules/1
      def destroy
        @api_v1_shop_schedule.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_api_v1_shop_schedule
        @api_v1_shop_schedule = Schedule.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Schedule not found' }, status: :not_found
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # Only allow a list of trusted parameters through.
      def api_v1_shop_schedule_params
        params.require(:api_v1_shop_schedule).permit(
          :day,
          :opening_time,
          :closing_time
        )
      end
    end
  end
end
