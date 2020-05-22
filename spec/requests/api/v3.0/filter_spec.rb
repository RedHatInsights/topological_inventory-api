RSpec.describe("::Insights::API::Common::Filter") do
  include ::Spec::Support::TenantIdentity
  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }

  def create_task(attrs = {})
    Task.create!(
      attrs.merge(
        :state  => "pending",
        :status => "ok",
        :tenant => tenant,
      )
    )
  end

  def expect_failure(query, *errors)
    get(URI.escape("/api/v3.0/tasks?#{query}"), :headers => headers)

    expect(response).to have_attributes(
      :parsed_body => {
        "errors" => errors.collect { |e| {"detail" => e, "status" => "400"} }
      },
      :status      => 400,
    )
  end

  def expect_success(query, *results)
    get(URI.escape("/api/v3.0/tasks?#{query}"), :headers => headers)

    expect(response).to have_attributes(
      :parsed_body => paginated_response(results.length, results.collect { |i| a_hash_including("id" => i.id.to_s) }),
      :status      => 200,
    )
  end

  def expect_tag_success(instance, query, *results)
    get(URI.escape("/api/v3.0/#{instance.class.name.underscore.pluralize}/#{instance.id}/tags?#{query}"), :headers => headers)

    expect(response).to have_attributes(
      :parsed_body => paginated_response(results.length, results.collect { |i| a_hash_including("tag" => i.to_tag_string) }),
      :status      => 200,
    )
  end

  context "strings" do
    let!(:task_1) { create_task(:name => "aaa") }
    let!(:task_2) { create_task(:name => "bbb") }
    let!(:task_3) { create_task(:name => "abc") }
    let!(:task_4) { create_task }
    let!(:task_5) { create_task(:name => "def%") }
    let!(:task_6) { create_task(:name => "%def") }
    let!(:task_7) { create_task(:name => "de%f") }

    it("key:eq single without 'eq' key")          { expect_success("filter[name]=#{task_1.name}", task_1) }
    it("key:eq array of values without 'eq' key") { expect_success("filter[name][]=#{task_1.name}&filter[name][]=#{task_2.name}", task_1, task_2) }
    it("key:eq single with 'eq' key")             { expect_success("filter[name][eq]=#{task_1.name}", task_1) }
    it("key:eq array of values with 'eq' key")    { expect_success("filter[name][eq][]=#{task_1.name}&filter[name][eq][]=#{task_2.name}", task_1, task_2) }

    it("key:contains single")                     { expect_success("filter[name][contains]=a", task_1, task_3) }
    it("key:contains array")                      { expect_success("filter[name][contains][]=a&filter[name][contains][]=b", task_3) }

    it("key:ends_with")                           { expect_success("filter[name][ends_with]=a", task_1) }
    it("key:starts_with")                         { expect_success("filter[name][starts_with]=b", task_2) }
    it("key:nil")                                 { expect_success("filter[name][nil]", task_4) }
    it("key:not_nil")                             { expect_success("filter[name][not_nil]", task_1, task_2, task_3, task_5, task_6, task_7) }

    it("key:ends_with %")                         { expect_success("filter[name][ends_with]=%", task_5) }
    it("key:starts_with %")                       { expect_success("filter[name][starts_with]=%", task_6) }
    it("key:contains %")                          { expect_success("filter[name][contains]=e%", task_7) }
  end

  context "integers" do
    let!(:task_1) { create_task }
    let!(:task_2) { create_task }
    let!(:task_3) { create_task }
    let!(:task_4) { create_task }

    it("key:eq single without 'eq' key")          { expect_success("filter[id]=#{task_1.id}", task_1) }
    it("key:eq array of values without 'eq' key") { expect_success("filter[id][]=#{task_1.id}&filter[id][]=#{task_2.id}", task_1, task_2) }
    it("single with 'eq' key")                    { expect_success("filter[id][eq]=#{task_1.id}", task_1) }
    it("array of values with 'eq' key")           { expect_success("filter[id][eq][]=#{task_1.id}&filter[id][eq][]=#{task_2.id}", task_1, task_2) }

    it("key:gt")                                  { expect_success("filter[id][gt]=#{task_2.id}", task_3, task_4) }
    it("key:gte")                                 { expect_success("filter[id][gte]=#{task_2.id}", task_2, task_3, task_4) }
    it("key:lt")                                  { expect_success("filter[id][lt]=#{task_3.id}", task_1, task_2) }
    it("key:lte")                                 { expect_success("filter[id][lte]=#{task_3.id}", task_1, task_2, task_3) }
  end

  context "timestamps" do
    let!(:task_1) { create_task }
    let!(:task_2) { create_task(:completed_at => Time.parse("2019-03-06T16:15Z").utc) }
    let!(:task_3) { create_task(:completed_at => Time.parse("2019-03-06T16:17Z").utc) }
    let!(:task_4) { create_task(:completed_at => Time.parse("2019-03-07T00:01Z").utc) }

    it("key:eq y-m-dTh:m:s single without 'eq' key") { expect_success("filter[completed_at]=2019-03-06T16:17:00", task_3) }
    it("key:eq y-m-dTh:m single without 'eq' key")   { expect_success("filter[completed_at]=2019-03-06T16:17", task_3) }
    it("key:eq y-m-dTh:m:s single with 'eq' key")    { expect_success("filter[completed_at][eq]=2019-03-06T16:17:00", task_3) }
    it("key:eq y-m-dTh:m single with 'eq' key")      { expect_success("filter[completed_at][eq]=2019-03-06T16:17", task_3) }

    it("key:eq y-m-dTh:m:s array without 'eq' key") { expect_success("filter[completed_at][]=2019-03-06T16:17:00&filter[completed_at][]=2019-03-06T16:15:00", task_2, task_3) }
    it("key:eq y-m-dTh:m array without 'eq' key")   { expect_success("filter[completed_at][]=2019-03-06T16:17&filter[completed_at][]=2019-03-06T16:15", task_2, task_3) }
    it("key:eq y-m-dTh:m:s array with 'eq' key")    { expect_success("filter[completed_at][eq][]=2019-03-06T16:17:00&filter[completed_at][eq][]=2019-03-06T16:15:00", task_2, task_3) }
    it("key:eq y-m-dTh:m array with 'eq' key")      { expect_success("filter[completed_at][eq][]=2019-03-06T16:17&filter[completed_at][eq][]=2019-03-06T16:15", task_2, task_3) }

    it("key:gt y-m-dTh:m:s") { expect_success("filter[completed_at][gt]=2019-03-06T16:16:05", task_3, task_4) }
    it("key:gt y-m-dTh:m")   { expect_success("filter[completed_at][gt]=2019-03-06T16:16", task_3, task_4) }
    it("key:gt y-m-d")       { expect_success("filter[completed_at][gt]=2019-03-06", task_2, task_3, task_4) }

    it("key:lt y-m-dTh:m:s") { expect_success("filter[completed_at][lt]=2019-03-06T16:17:05", task_2, task_3) }
    it("key:lt y-m-dTh:m")   { expect_success("filter[completed_at][lt]=2019-03-06T16:17", task_2) }
    it("key:lt y-m-d")       { expect_success("filter[completed_at][lt]=2019-03-06") }

    it("key:nil")            { expect_success("filter[completed_at][nil]", task_1) }
    it("key:not_nil")        { expect_success("filter[completed_at][not_nil]", task_2, task_3, task_4) }
  end

  context "sorted results via sort_by" do
    before do
      source = Source.create!(:tenant => tenant)
      Vm.create!(:name => "sort_by_vm_a", :source => source, :tenant => tenant, :source_ref => "vm_a")
      Vm.create!(:name => "sort_by_vm_b", :source => source, :tenant => tenant, :source_ref => "vm_b")
    end

    it "available for vms with default order" do
      get("/api/v3.0/vms?filter[name][starts_with]=sort_by_vm&sort_by[name]", :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body["data"].collect { |vm| vm["name"] }).to eq(%w[sort_by_vm_a sort_by_vm_b])
    end

    it "available for vms with desc order" do
      get("/api/v3.0/vms?filter[name][starts_with]=sort_by_vm&sort_by[name]=desc", :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body["data"].collect { |vm| vm["name"] }).to eq(%w[sort_by_vm_b sort_by_vm_a])
    end
  end

  context "error cases" do
    it("empty filter")      { expect_failure("filter", "ActionController::UnpermittedParameters: found unpermitted parameter: :filter") }
    it("unknown attribute") { expect_failure("filter[xxx]", "Insights::API::Common::Filter::Error: found unpermitted parameter: xxx") }

    context "unsupported comparator" do
      it("on an integer")  { expect_failure("filter[id][xxx]=4", "Insights::API::Common::Filter::Error: found unpermitted parameter: id.xxx") }
      it("on a string")    { expect_failure("filter[name][xxx]=4", "Insights::API::Common::Filter::Error: found unpermitted parameter: name.xxx") }
      it("on a timestamp") { expect_failure("filter[created_at][xxx]=4", "Insights::API::Common::Filter::Error: found unpermitted parameter: created_at.xxx") }
    end

    it "unsupported attribute type" do
      source = Source.create!(:tenant => tenant)
      Vm.create!(:source => source, :tenant => tenant, :source_ref => "a")

      get("/api/v3.0/vms?filter[mac_addresses]=a", :headers => headers)

      expect(response.status).to eq(400)
      expect(response.parsed_body["errors"]).to eq([{"detail"=>"Insights::API::Common::Filter::Error: unsupported attribute type for: mac_addresses", "status"=>"400"}])
    end

    it "invalid attribute" do
      source = Source.create!(:tenant => tenant)
      Vm.create!(:source => source, :tenant => tenant, :source_ref => "a")

      get("/api/v3.0/vms?filter[bogus_attribute]=a", :headers => headers)

      expect(response.status).to eq(400)
      expect(response.parsed_body["errors"]).to eq([{"detail"=>"Insights::API::Common::Filter::Error: found unpermitted parameter: bogus_attribute", "status"=>"400"}])
    end

    it "multiple invalid attributes mixed with a valid attribute" do
      source = Source.create!(:tenant => tenant)
      Vm.create!(:source => source, :tenant => tenant, :source_ref => "a")

      get("/api/v3.0/vms?filter[mac_addresses]=a&filter[name]=a&filter[bogus_attribute]=b", :headers => headers)

      expect(response.status).to eq(400)
      expect(response.parsed_body["errors"]).to eq(
        [
          {"detail" => "Insights::API::Common::Filter::Error: unsupported attribute type for: mac_addresses, found unpermitted parameter: bogus_attribute", "status" => "400"}
        ]
      )
    end
  end

  context "undocumented attributes" do
    it "does not display #tenant_id" do
      task = create_task

      get("/api/v3.0/tasks/#{task.id}")

      expect(response.parsed_body.keys).not_to include("tenant_id")
    end

    it "displays #tenant_id if given through the extra_filterable_attributes" do
      expect(Task.count).to eq(0)
      task = create_task
      expect(Task.count).to eq(1)

      schema   = ::Insights::API::Common::OpenApi::Docs.instance["2.0"].schemas["Task"]
      filtered = ::Insights::API::Common::Filter.new(Task, {"tenant_id" => tenant.id.to_s}, schema, {"tenant_id" => {"type" => "string"}}).apply

      expect(filtered.length).to eq(1)
      expect(filtered.first["id"]).to eq(task.id)
    end
  end

  context "tag attributes" do
    let(:container_node) { ContainerNode.create!(:source => source, :source_ref => "something", :tenant => tenant) }
    let(:source)         { Source.create!(:tenant => tenant) }
    let!(:tag_1)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "aaa").tap { |i| container_node.tags << i } }
    let!(:tag_2)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "bbb").tap { |i| container_node.tags << i } }
    let!(:tag_3)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "abc").tap { |i| container_node.tags << i } }
    let!(:tag_4)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "xyz").tap { |i| container_node.tags << i } }
    let!(:tag_5)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "def%").tap { |i| container_node.tags << i } }
    let!(:tag_6)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "%def").tap { |i| container_node.tags << i } }
    let!(:tag_7)         { Tag.create!(:tenant => tenant, :namespace => "test_namespace", :name => "de%f").tap { |i| container_node.tags << i } }

    it("key:eq single without 'eq' key")          { expect_tag_success(container_node, "filter[name]=#{tag_1.name}", tag_1) }
    it("key:eq array of values without 'eq' key") { expect_tag_success(container_node, "filter[name][]=#{tag_1.name}&filter[name][]=#{tag_2.name}", tag_1, tag_2) }
    it("key:eq single with 'eq' key")             { expect_tag_success(container_node, "filter[name][eq]=#{tag_1.name}", tag_1) }
    it("key:eq array of values with 'eq' key")    { expect_tag_success(container_node, "filter[name][eq][]=#{tag_1.name}&filter[name][eq][]=#{tag_2.name}", tag_1, tag_2) }

    it("key:contains single")                     { expect_tag_success(container_node, "filter[name][contains]=a", tag_1, tag_3) }
    it("key:contains array")                      { expect_tag_success(container_node, "filter[name][contains][]=a&filter[name][contains][]=b", tag_3) }

    it("key:ends_with")                           { expect_tag_success(container_node, "filter[name][ends_with]=a", tag_1) }
    it("key:starts_with")                         { expect_tag_success(container_node, "filter[name][starts_with]=b", tag_2) }

    # No nillable columns at this time
    it("key:nil")                                 { expect_tag_success(container_node, "filter[name][nil]") }
    it("key:not_nil")                             { expect_tag_success(container_node, "filter[name][not_nil]", tag_1, tag_2, tag_3, tag_4, tag_5, tag_6, tag_7) }

    it("key:ends_with %")                         { expect_tag_success(container_node, "filter[name][ends_with]=%", tag_5) }
    it("key:starts_with %")                       { expect_tag_success(container_node, "filter[name][starts_with]=%", tag_6) }
    it("key:contains %")                          { expect_tag_success(container_node, "filter[name][contains]=e%", tag_7) }
  end
end
