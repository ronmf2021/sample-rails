require 'rails_helper'

RSpec.describe "Books", type: :request do
    context "GET #index" do
        it "should success" do
            get books_path
            expect(response).to be_successful
        end

        it "should render template" do
            get books_path
            expect(response).to render_template("index")
        end
    end

    context "GET #show" do
        
    end
    
    
end
