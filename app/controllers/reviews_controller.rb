class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
    @recensito= params[:id]
    @reviewer= current_user.id
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
    @reviewer= current_user.id
    @reviewed= params[:reviewed]
  end

  # GET /reviews/1/edit
  def edit
    @reviewer= current_user.id
    @reviewed= Review.find(params[:id]).reviewed
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    @reviewed= review_params[:reviewed]
    respond_to do |format|
      if @review.save
        format.html { redirect_to "/reviews?id=" + @reviewed}
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    @reviewed= review_params[:reviewed]
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to "/reviews?id=" + @reviewed }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:reviewer, :reviewed, :stars, :testo)
    end
end
