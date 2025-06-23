module ProjectsHelper
    def project_id_kw_table
    {
    title: "Keywords",
    columns: [ "#", "Keyword", "Search Volume" ],
    entry_key: "name",
    styling: {
      parent_wrapper: "text-gray-600 row-span-3 col-span-2 text-left font-medium  h-auto",
      table_scroll_behavior: "overflow-y-scroll max-h-150",
      table_header_styling: "bg-neutral-200",

      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center w-2",
        name_styling: " px-1 max-w-20 overflow-hidden truncate whitespace-nowrap text-ellipsis",
        keyword_styling: " px-1 w-5 overflow-hidden truncate whitespace-nowrap text-ellipsis "
      }

    },
    include: {
      kw_count: true
    }
  }
  end


  def project_id_insights_table
    {
    title: "URLs",
    columns: [ "#", "URL", "SV", "Est Traffic", "KW Count" ],
    urls: @top_urls,
    entry_key: "name",
    styling: {
      parent_wrapper: "bg-white text-gray-600 text-left font-medium text-sm flex-1",
      table_header_styling: "text-red-500 text-sm bg-white ",
      table_scroll_behavior: "overflow-y-scroll w-full flex-1 max-h-65",
      overflow: "overflow-y-scroll ",
      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5 w-4",
        name_styling: "p-0.5 px-1 max-w-40 overflow-hidden truncate whitespace-nowrap flex-1",
        keyword_styling: "p-.5 px-1 w-4 overflow-hidden truncate whitespace-nowrap"
      }
    },

    include: {
      traffic: true,
      kw_count: true
    }
}
  end

  def project_id_category_table
    {
    title: "Categories",
    columns: [ "#", "Category", "Volume", "Est. Traffic", "KW Count" ],
    entries: @top_categories,
    entry_key: "name",
    styling: {
      parent_wrapper: " bg-white text-gray-600 text-left font-medium text-sm h-1/2 max-h-1/2",
      table_header_styling: "text-red-500 text-sm bg-white",
      table_scroll_behavior: "overflow-y-scroll max-h-20",
      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5",
        name_styling: "p-0.5 px-1 w-2/5 overflow-hidden truncate whitespace-nowrap",
        keyword_styling: "p-.5 px-1 w-4 overflow-hidden truncate whitespace-nowrap"
      }
    },
    table_primary_field: "url"


  }
  end



def project_id_ngram_table
    {
    title: "Phrases",
    columns: [ "#", "Phrase", "Weighted Freq.", "Count" ],
    entries:  @ngrams,
    entry_key: "phrase",
    styling: {
      parent_wrapper: "bg-white text-gray-600 text-left font-medium text-sm flex-1",
      table_header_styling: "text-red-500 text-sm bg-white ",
      table_scroll_behavior: "overflow-y-scroll w-full flex-1 max-h-65",
      overflow: "overflow-y-scroll ",
      table_body_styling: {
        row_border: "border border-dashed border-red-500",
        index_styling: "border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5 w-4",
        name_styling: "p-0.5 px-1 max-w-40 overflow-hidden truncate whitespace-nowrap flex-1",
        keyword_styling: "p-.5 px-1 w-4 overflow-hidden truncate whitespace-nowrap"
      }
    },
    table_primary_field: "url",
    include: {
      kw_count: true
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
