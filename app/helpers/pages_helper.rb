# frozen_string_literal: true

module PagesHelper
  def project_id_kw_table
    {
      title: 'Keywords',
      columns: ['#', 'Keyword', 'Search Volume'],
      entry_key: :name,
      styling: {
        parent_wrapper: 'bg-white project_id_kw_table ',
        table_scroll_behavior: 'overflow-y-scroll max-h-100',
        table_header_styling: 'bg-neutral-200',

        table_body_styling: {
          row_border: 'border border-dashed border-red-500',
          index_styling: 'border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5',
          name_styling: 'p-0.5 px-1 w-full overflow-hidden truncate whitespace-nowrap',
          keyword_styling: 'p-.5 px-1 overflow-hidden truncate whitespace-nowrap'
        }

      },
      include: {
        kw_count: true
      }
    }
  end

  def home_projects_table
    {
      title: 'Projects',
      columns: ['#', 'Title', 'Total SV'],
      entry_key: :name,
      styling: {
        parent_wrapper: 'text-gray-600 row-span-3 col-span-2 text-left font-medium h-auto bg-white mt-4 px-5 rounded-sm shadow-md w-full',
        table_scroll_behavior: 'overflow-y-scroll w-full flex-1 max-h-65',
        overflow: 'overflow-y-scroll ',
        table_header_styling: 'bg-neutral-200',
        table_heading: 'text-red-500',
        table_body_styling: {
          row_border: nil,
          index_styling: 'border-r border-dashed border-red-500 p-0.5 px-1 text-center h-5 text-gray-500',
          name_styling: 'pl-0.5 px-1 w-full overflow-hidden truncate whitespace-nowrap text-gray-500',
          keyword_styling: 'p-.5 px-1 overflow-hidden truncate whitespace-nowrap text-gray-500'
        }

      },
      include: {
        kw_count: false
      }
    }
  end
end
