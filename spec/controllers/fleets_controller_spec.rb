require 'rails_helper'

describe FleetsController do
  let!(:user) { User.create!(email: "one@user.com", role: User.roles["user"], full_name: "User One", password: "password") }

  context "with a signed in user" do
    before do
      sign_in user
    end

    describe "GET #index" do
      context "API" do
        let(:default_params) { {
          format: "json",
          "aircraft_status"=>["Active"],
          "display_count"=>"25",
          "sort_column"=>"msn",
          "sort_direction"=>"asc",
          "selected"=>["msn", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "airline"],
          "available"=>["aircraft_version", "registration", "engine_model", "engine_version", "owner", "airline_country", "build_year", "aircraft_age", "seats", "mtow", "hours_cumulative", "cycles_cumulative"]
        } }

        it "works" do
          get :index, default_params

          expect(response.status).to eq(200)
          response_json = JSON.parse(response.body)

          expect(response_json["column_names"]).to eq(["msn", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "airline"])
          expect(response_json["sort_column"]).to eq("msn")
          expect(response_json["sort_direction"]).to eq("asc")
          expect(response_json["fleets"]).to be
        end
      end

      context "html" do
        let(:default_params) { {} }

        context "happy path" do
          it "works" do
            get :index, default_params

            expect(response.status).to eq(200)
            expect(assigns[:prezi]).to be_is_a(FleetsPresenter)
          end
        end
      end
    end
  end
end
