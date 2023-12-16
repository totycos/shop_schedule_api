# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/schedules', type: :request do
  before(:each) do
    @shop = Shop.create(name: 'Castoramax')
    @schedule = create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop: @shop)
    @schedule2 = create(:schedule, day: 'Monday', opening_time: '13:00', closing_time: '18:00', shop: @shop)
  end

  describe 'GET /index' do
    it 'return http success' do
      get api_v1_shop_schedules_url(@shop)
      expect(response).to have_http_status(:success)
    end

    it 'returns full ordered schedule ' do
      get api_v1_shop_schedules_url(@shop), as: :json
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)

      current_day = Time.now.strftime('%A').downcase
      day_names = Schedule.days.keys.map(&:to_s)
      sorted_days = day_names.rotate(day_names.index(current_day))
      current_day_index = sorted_days.index(current_day)

      expect(json[0]['day']).to eq(I18n.t("date.day_names.#{sorted_days[current_day_index].downcase}"))
      expect(json[0]['opening_time']).to eq(@shop.schedules.find_by(day: sorted_days[current_day_index]).opening_time)
      expect(json[0]['closing_time']).to eq(@shop.schedules.find_by(day: sorted_days[current_day_index]).closing_time)
    end
  end

  describe 'GET /show' do
    it 'return http success' do
      schedule_id = @shop.schedules.first.id
      get api_v1_shop_schedule_path(@shop, schedule_id), as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns schedule for a day' do
      schedule_id = @shop.schedules.first.id
      get api_v1_shop_schedule_path(@shop, schedule_id), as: :json
      json = JSON.parse(response.body)
      expect(json['id']).to eq(@shop.schedules.first.id)
      expect(json['day']).to eq(I18n.t("date.day_names.#{@shop.schedules.first.day.downcase}"))
      expect(json['opening_time']).to eq(@shop.schedules.first.opening_time)
      expect(json['closing_time']).to eq(@shop.schedules.first.closing_time)
      expect(json.size).to eq(4)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        post api_v1_shop_schedules_url(@shop), params: {
          api_v1_shop_schedule: {
            day: :tuesday,
            opening_time: '08:30',
            closing_time: '12:00'
          }
        }, as: :json
      end

      it 'returns the 4 schedule elements' do
        expect(response.body).to include('Mardi')
        expect(response.body).to include('08:30')
        expect(response.body).to include('12:00')
        expect(response.body).to include(@shop.id.to_s)
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      before do
        post api_v1_shop_schedules_url(@shop), params: {
          api_v1_shop_schedule: {
            day: '',
            opening_time: '08:30',
            closing_time: '12:00'
          }
        }, as: :json
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      before do
        schedule_id = @shop.schedules.first.id
        patch api_v1_shop_schedule_url(@shop, schedule_id), params: {
          api_v1_shop_schedule: {
            day: :monday,
            opening_time: '09:30',
            closing_time: '12:30'
          }
        }, as: :json
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated times' do
        expect(response.body).to include('09:30')
        expect(response.body).to include('12:30')
      end
    end

    context 'with invalid parameters' do
      before do
        schedule_id = @shop.schedules.first.id
        patch api_v1_shop_schedule_url(@shop, schedule_id), params: {
          api_v1_shop_schedule: {
            day: :monday,
            opening_time: '09:70',
            closing_time: '12:30'
          }
        }, as: :json
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested shop' do
      schedule_id = @shop.schedules.first.id
      expect do
        delete api_v1_shop_schedule_url(@shop, schedule_id), as: :json
      end.to change(Schedule, :count).by(-1)
    end
  end
end