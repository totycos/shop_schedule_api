# frozen_string_literal: true

module Api
  module V1
    # Controller responsible for handling API requests related to shops.
    class ShopsController < ApplicationController
      before_action :set_api_v1_shop, only: %i[show update destroy]

      # GET /api/v1/shops
      def index
        @api_v1_shops = Shop.all.includes(:schedules)
        render json: @api_v1_shops
      end

      # GET /api/v1/shops/1
      def show
        render json: @api_v1_shop
      end

      # POST /api/v1/shops
      def create
        @api_v1_shop = Shop.create!(api_v1_shop_params)
        render json: @api_v1_shop, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      # PATCH/PUT /api/v1/shops/1
      def update
        @api_v1_shop.update!(api_v1_shop_params)
        render json: @api_v1_shop
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      # DELETE /api/v1/shops/1
      def destroy
        @api_v1_shop.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_api_v1_shop
        @api_v1_shop = Shop.find(params[:id])
      rescue ActiveRecord::RecordNotFound # Rescue if ID not found
        render json: { error: 'Shop not found' }, status: :not_found
      rescue StandardError => e # Rescue for other errors
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # Only allow a list of trusted parameters through.
      def api_v1_shop_params
        params.require(:api_v1_shop).permit(:name)
      end
    end
  end
end
