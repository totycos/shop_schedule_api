class Api::V1::SchedulesController < ApplicationController
  before_action :set_api_v1_schedule, only: %i[ show update destroy ]

  # GET /api/v1/schedules
  def index
    @api_v1_schedules = Api::V1::Schedule.all

    render json: @api_v1_schedules
  end

  # GET /api/v1/schedules/1
  def show
    render json: @api_v1_schedule
  end

  # POST /api/v1/schedules
  def create
    @api_v1_schedule = Api::V1::Schedule.new(api_v1_schedule_params)

    if @api_v1_schedule.save
      render json: @api_v1_schedule, status: :created, location: @api_v1_schedule
    else
      render json: @api_v1_schedule.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/schedules/1
  def update
    if @api_v1_schedule.update(api_v1_schedule_params)
      render json: @api_v1_schedule
    else
      render json: @api_v1_schedule.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/schedules/1
  def destroy
    @api_v1_schedule.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_schedule
      @api_v1_schedule = Api::V1::Schedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_schedule_params
      params.fetch(:api_v1_schedule, {})
    end
end
