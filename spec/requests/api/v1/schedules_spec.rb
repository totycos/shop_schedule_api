# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/schedules', type: :request do
  let(:shop) do
    create(:shop, name: 'Castoramax').tap do |s|
      create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop: s)
      create(:schedule, day: 'Monday', opening_time: '13:00', closing_time: '18:00', shop: s)
    end
  end

  let(:schedule_id) { shop.schedules.first.id }

  def expected_day(shop)
    current_day = 'tuesday' # Time.now.strftime('%A').downcase
    day_names = Schedule.days.keys.map(&:to_s)
    sorted_days = day_names.rotate(day_names.index(current_day))

    if schedule_exists_for_day?(shop, current_day)
      current_day
    else
      find_closest_day(shop, sorted_days)
    end
  end

  def schedule_exists_for_day?(shop, day)
    shop.schedules.any? { |schedule| schedule['day'].casecmp(day).zero? }
  end

  def find_closest_day(shop, sorted_days)
    sorted_days.find do |day|
      schedule_exists_for_day?(shop, day)
    end
  end

  describe 'GET /index' do
    before do
      get api_v1_shop_schedules_url(shop), as: :json
    end

    let(:json) { JSON.parse(response.body) }

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns full ordered schedule ' do # rubocop:disable RSpec/MultipleExpectations
      day_key = "date.day_names.#{expected_day(shop)}"

      expect(json.size).to eq(2)
      expect(json[0]['day']).to eq(I18n.t(day_key))
      expect(json[0]['opening_time'].to_datetime).to eq(shop.schedules.find_by(day: expected_day(shop)).opening_time)
      expect(json[0]['closing_time'].to_datetime).to eq(shop.schedules.find_by(day: expected_day(shop)).closing_time)
    end

    it 'Check if the opening_time are sorted properly for a same day' do
      json.each_cons(2) do |schedule1, schedule2|
        opening_time1 = Time.parse(schedule1['opening_time'])
        opening_time2 = Time.parse(schedule2['opening_time'])

        expect(opening_time1).to be < opening_time2
      end
    end
  end

  describe 'GET /show' do
    before { get api_v1_shop_schedule_path(shop, schedule_id), as: :json }

    let(:json) { JSON.parse(response.body) }

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns schedule for a day' do # rubocop:disable RSpec/MultipleExpectations
      day_key = "date.day_names.#{shop.schedules.first.day.downcase}"
      expect(json['id']).to eq(shop.schedules.first.id)
      expect(json['day']).to eq(I18n.t(day_key))
      expect(json['opening_time'].to_datetime).to eq(shop.schedules.first.opening_time)
      expect(json['closing_time'].to_datetime).to eq(shop.schedules.first.closing_time)
      expect(json.size).to eq(4)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        I18n.with_locale(:fr) do
          post api_v1_shop_schedules_url(shop), params: {
            api_v1_shop_schedule: {
              day: :tuesday,
              opening_time: '08:30',
              closing_time: '12:00'
            }
          }, as: :json
        end
      end

      it 'returns the 4 schedule elements' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        I18n.with_locale(:fr) do
          expect(response.body).to include('Mardi')
          expect(response.body).to include('08:30')
          expect(response.body).to include('12:00')
          expect(response.body).to include(shop.id.to_s)
        end
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      before do
        post api_v1_shop_schedules_url(shop), params: {
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
        patch api_v1_shop_schedule_url(shop, schedule_id), params: {
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

      it 'returns the updated times' do # rubocop:disable RSpec/MultipleExpectations
        expect(response.body).to include('09:30')
        expect(response.body).to include('12:30')
      end
    end

    context 'with invalid parameters' do
      before do
        patch api_v1_shop_schedule_url(shop, schedule_id), params: {
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
      schedule_id = shop.schedules.first.id
      expect { delete api_v1_shop_schedule_url(shop, schedule_id), as: :json }
        .to change(Schedule, :count).by(-1)
    end
  end
end
