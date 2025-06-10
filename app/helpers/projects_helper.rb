module ProjectsHelper
  def project_id_insights_table
    {
    title: "Insights",
    columns: [ "#", "URL", "SV", "Est Traffic" ],
    urls: @top_urls,
    styling: {
      parent_wrapper: "project_id_insights_table",
      table_header_styling: "color-red-500",
      table_scroll_behavior: "overflow-y-scroll max-h-20",
      overflow: "overflow-y-scroll max-h-20",
      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5",
        name_styling: "p-0.5 px-1 w-full overflow-hidden truncate whitespace-nowrap",
        keyword_styling: "p-.5 px-1 overflow-hidden truncate whitespace-nowrap"
      }
    },

    include: {
      traffic: true
    }
}
  end

  def project_id_category_table
    {
    title: nil,
    columns: [ "#", "Category", "Volume" ],
    styling: {
      parent_wrapper: "project_id_category_table",
      table_header_styling: "text-red-500 text-xl",
      table_scroll_behavior: "overflow-y-scroll max-h-20",
      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5",
        name_styling: "p-0.5 px-1 w-full overflow-hidden truncate whitespace-nowrap",
        keyword_styling: "p-.5 px-1 overflow-hidden truncate whitespace-nowrap"
      }
    },
    table_primary_field: "url"


  }
  end

  def project_id_kw_table
    {
    title: "Keywords",
    columns: [ "#", "Keyword", "Search Volume" ],
    styling: {
      parent_wrapper: "project_id_kw_table",
      table_scroll_behavior: nil,
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
  def kw_columns
    [ "#", "Keyword", "Search Volume" ]
  end
  def project_columns
    [ "#", "Name", "Insight" ]
  end
end
