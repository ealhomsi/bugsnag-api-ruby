require "spec_helper"

describe Bugsnag::Api::Client::EventFields do
    before do
        @client = auth_token_client
        @project_id = test_bugsnag_project_id
        Bugsnag::Api.reset!
    end

    describe ".create_event_field" do
        it "create a new eventfield for the project" do
            newEventfield = client.create_event_field @project_id, "event_field_test_id", "metadata/user"
            expect(newEventfield.display_id).to eq("event_field_test_id")

            assert_requested :post, bugsnag_url("/projects/#{@project_id}/event_fields")
        end
    end

    context "given an event field exists"
        before do
            @eventfield = client.create_event_field @project_id, "event_field_test", "metadata/pivot"
        end

        describe ".list_event_fields", :vcr do
            it "lists project eventfields" do
                eventfields = @client.list_event_fields @project_id
                expect(eventfields).to be_kind_of(Array)
                expect(eventfields).to include(@eventfield)

                assert_requested :get, bugsnag_url("/projects/#{@project_id}/event_fields")
            end
        end

        describe ".update_event_field", :vcr do
            it "updates and returns the event field" do
                updatedEventfield = client.update_event_field @project_id, @eventfield.display_id, "metadata/test", {:pivot_options => {:name => "pivot_test"}}
                expect(updatedEventfield.display_id).to eq(@eventfield.display_id)
                expect(updatedEventfield.pivot_options.name).to eq("pivot_test")

                assert_requested :patch, bugsnag_url("/projects/#{@project_id}/event_fields/#{@eventfield.display_id}")
            end
        end

        describe ".delete_event_field", :vcr do
            it "deletes the event field" do
                deletedEventfield = client.delete_event_field @project_id, @eventfield.display_id
                expect(deletedEventfield).to be true

                assert_requested :delete, bugsnag_url("/projects/#{@project_id}/event_fields/#{@eventfield.display_id}")
            end
        end
    end
end