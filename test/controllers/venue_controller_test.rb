require 'test_helper'

class VenueControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get venue_index_url
    assert_response :success
  end

  test 'should get new' do
    get venue_new_url
    assert_response :success
  end

  test 'should get create' do
    get venue_create_url
    assert_response :success
  end

  test 'should get listing' do
    get venue_listing_url
    assert_response :success
  end

  test 'should get payout' do
    get venue_payout_url
    assert_response :success
  end

  test 'should get description' do
    get venue_description_url
    assert_response :success
  end

  test 'should get photo_upload' do
    get venue_photo_upload_url
    assert_response :success
  end

  test 'should get genre' do
    get venue_genre_url
    assert_response :success
  end

  test 'should get location' do
    get venue_location_url
    assert_response :success
  end

  test 'should get update' do
    get venue_update_url
    assert_response :success
  end
end
