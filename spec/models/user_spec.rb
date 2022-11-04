require 'rails_helper'

=begin

t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
=end

RSpec.describe User, type: :model do
  context "inserisco utente senza ruolo" do
    it "non dovrebbe crearlo" do
      user=User.new(email: "utente@gmail",id: "1",password: 'password1234')
      expect(user).to_not be_valid
    end
  end
  context "inserisco utente senza email" do
    it "non dovrebbe crearlo" do
      user=User.new(ruolo: "Manager",id: "1", password: 'password1234')
      expect(user).to_not be_valid
    end
  end
  context "inserisco utente senza password" do
    it "non dovrebbe crearlo" do
      user=User.new(email: "utente@gmail",id: "1", ruolo: 'cliente')
      expect(user).to_not be_valid
    end
  end
  describe "creo utente con parametri richiesti " do
    it "dovrebbe crearlo" do
        user = User.create(email:"utente@gmail" ,ruolo: 'cliente', password: 'password1234', password_confirmation: 'password1234')
        expect(user).to be_valid
    end
  end
end
