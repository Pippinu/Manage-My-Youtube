require "application_system_test_case"

class ReviewsTest < ApplicationSystemTestCase
  setup do
    @review = reviews(:one)
  end

  test "visiting the index" do
    visit reviews_url
    assert_selector "h1", text: "Reviews"
  end

  test "should create review" do
    visit reviews_url
    click_on "New review"

    fill_in "Reviewed", with: @review.reviewed
    fill_in "Reviewer", with: @review.reviewer
    fill_in "Stars", with: @review.stars
    fill_in "Testo", with: @review.testo
    click_on "Create Review"

    assert_text "Review was successfully created"
    click_on "Back"
  end

  test "should update Review" do
    visit review_url(@review)
    click_on "Edit this review", match: :first

    fill_in "Reviewed", with: @review.reviewed
    fill_in "Reviewer", with: @review.reviewer
    fill_in "Stars", with: @review.stars
    fill_in "Testo", with: @review.testo
    click_on "Update Review"

    assert_text "Review was successfully updated"
    click_on "Back"
  end

  test "should destroy Review" do
    visit review_url(@review)
    click_on "Destroy this review", match: :first

    assert_text "Review was successfully destroyed"
  end
end
