class AffiliationsController < ApplicationController
  before_action :set_affiliation, only: %i[ show edit update destroy ]

  # GET /affiliations or /affiliations.json
  def index
    @affiliations = Affiliation.all
  end

  # GET /affiliations/1 or /affiliations/1.json
  def show
  end

  # GET /affiliations/new
  def new
    @affiliation = Affiliation.new

    @azienda=params[:azienda]
    
    if current_user.ruolo=="cliente"
      @cliente= current_user.id
      @manager= params[:manager]
    else 
      @cliente= params[:cliente]
      @manager= current_user.id
    end


  end

  # GET /affiliations/1/edit
  def edit
  end

 # GET /affiliations/accept?id=...

  def accept
    @affiliazione= Affiliation.find(params[:id])
    @affiliazione.update_attribute(:status, "accepted")
  end

  # POST /affiliations or /affiliations.json
  def create
    @affiliation = Affiliation.new(affiliation_params)
    @cliente= affiliation_params[:cliente]
    @manager= affiliation_params[:manager]
    @azienda= affiliation_params[:azienda]
    respond_to do |format|
      if @affiliation.save
        if current_user.ruolo=="cliente"
          format.html { redirect_to "/cliente/managerprofile?id="+@manager}
          format.json { render :show, status: :created, location: @affiliation }
        end
        if current_user.ruolo=="manager"
          format.html { redirect_to "/manager"}
          format.json { render :show, status: :created, location: @affiliation }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @affiliation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /affiliations/1 or /affiliations/1.json
  def update
    respond_to do |format|
      if @affiliation.update(affiliation_params)
        format.html { redirect_to affiliation_url(@affiliation), notice: "Affiliation was successfully updated." }
        format.json { render :show, status: :ok, location: @affiliation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @affiliation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /affiliations/1 or /affiliations/1.json
  def destroy
    @manager=@affiliation.manager
    @affiliation.destroy

    respond_to do |format|
      if current_user.ruolo=="cliente"
        format.html { redirect_to "/cliente/managerprofile?id="+@manager }
      else 
        format.html { redirect_to "/manager/affiliazioni"}
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_affiliation
      @affiliation = Affiliation.find(params[:id])
      @affiliation.update_attribute(:status, "accepted")
      respond_to do |format|
        if current_user.ruolo=="manager"
          format.html { redirect_to "/manager/affiliazioni"}
        end
        if current_user.ruolo=="azienda"
          format.html { redirect_to "/azienda/affiliazioni"}
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def affiliation_params
      params.require(:affiliation).permit(:cliente, :manager, :azienda, :status)
    end
end
