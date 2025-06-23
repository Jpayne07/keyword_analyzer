module PagesHelper
    def project_id_kw_table
    {
    title: "Keywords",
    columns: [ "#", "Keyword", "Search Volume" ],
    entry_key: "name".to_sym,
    styling: {
      parent_wrapper: "project_id_kw_table",
      table_scroll_behavior: "overflow-y-scroll max-h-100",
      table_header_styling: "bg-neutral-200",

      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5",
        name_styling: "p-0.5 px-1 w-full overflow-hidden truncate whitespace-nowrap",
        keyword_styling: "p-.5 px-1 overflow-hidden truncate whitespace-nowrap"
      }

    },
    include: {
      kw_count: true
    }
  }
    end
  def home_projects_table
    {
    title: "Keywords",
    columns: [ "#", "Keyword", "Search Volume" ],
    styling: {
      parent_wrapper: "home_projects_table",
      table_scroll_behavior: "overflow-y-scroll max-h-100",
      table_header_styling: nil,
      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5",
        name_styling: "p-0.5 px-1 w-full overflow-hidden truncate whitespace-nowrap",
        keyword_styling: "p-.5 px-1 overflow-hidden truncate whitespace-nowrap"
      }

    }
  }
  end
end
