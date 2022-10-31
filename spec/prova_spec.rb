
#require "classe_prova1"
#ActionController::Base
require "affiliations_controller1"
require "application_controller1"
require "affiliation1"
require "user1"

describe AffiliationsController do
    describe ".createaff" do 
        #let(:pre_condition) { 'include ActionController' }
        context "dato cliente e manager " do 
            it "crea affiliazione" do 
                manager1=User.new("manager@p","cliente","1")
                client1=User.new("cliente@p","manager","2")
                print manager1.email
                expect(AffiliationsController.createaff(client1,manager1,"null")).to eq("affiliazione salvata")
            end
              
        end
    end
end

=begin
describe ClasseProva1 do 

    describe ".add" do 
        context "given an empty string" do 
            it "returns zero" do 
                expect(ClasseProva1.add("")).to eq(0)
            end
              
        end
        context "given numero x" do 
            it "returns x" do 
                expect(ClasseProva1.add("4")).to eq(4)
                    
                  
            end
        end

    end
end
=end