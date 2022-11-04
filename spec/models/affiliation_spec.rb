require 'rails_helper'

RSpec.describe Affiliation, type: :model do
  context "creo affiliazione senza manager" do
    it "non dovrebbe crearla" do
      aff=Affiliation.new(cliente: "cliente1",azienda: "azienda1")
      expect(aff).to_not be_valid
    end
  end
  context "creo affiliazione senza azienda" do
    it "dovrebbe crearla" do
      aff=Affiliation.new(cliente: "cliente1",manager: "manager1")
      expect(aff).to be_valid
    end
  end
  context "creo affiliazione senza cliente" do
    it "non dovrebbe crearla" do
      aff=Affiliation.new(manager: "manager1",azienda: "azienda1")
      expect(aff).to_not be_valid
    end
  end
  context "creo affiliazione completa con azienda" do
    it "dovrebbe crearla" do
      aff=Affiliation.new(cliente: "cliente1",manager: "manager1",azienda: "azienda1")
      expect(aff).to be_valid
    end
  end
  context "creo affiliazione completa no azienda" do
    it "dovrebbe crearla" do
      aff=Affiliation.new(cliente: "cliente1",manager: "manager1",azienda: "null")
      expect(aff).to be_valid
    end
  end
end
