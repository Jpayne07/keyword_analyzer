module ProjectsHelper
  def project_id_insights_table
    {
    title: "Insights",
    columns: [ "#", "Name", "Insight" ],
    styling: {
      parent_wrapper: "project_id_insights_table",
      table_header_styling: "color-red-500",
      table_scroll_behavior: "overflow-y-scroll max-h-20"
    },
    overflow: "overflow-y-scroll max-h-20"
  }
  end

  def project_id_category_table
    {
    title: nil,
    columns: [ "#", "Category", "Volume" ],
    styling: {
      parent_wrapper: "project_id_category_table",
      table_header_styling: "text-red-500 text-xl",
      table_scroll_behavior: "overflow-y-scroll max-h-20"
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
      table_header_styling: nil,
      table_scroll_behavior: nil
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
