# frozen_string_literal: true

module ProjectsHelper
  def parent_wrapper = 'bg-white text-gray-600 text-left font-medium text-sm flex-1 mt-4 px-5 rounded-sm shadow-md h-60'

  def table_body_styling
    {
      row_border: 'border border-dashed border-red-500',
      index_styling: 'border-x border-dashed border-red-500 p-0.5 px-1 text-center h-5 w-4',
      name_styling: 'p-0.5 px-1 max-w-40 overflow-hidden truncate whitespace-nowrap flex-1',
      keyword_styling: 'px-5 px-1 w-4 overflow-hidden truncate whitespace-nowrap'
    }
  end

  def project_id_kw_table
    {
      title: 'Keywords',
      columns: ['#', 'Keyword', 'Search Volume'],
      entry_key: 'name',
      styling: {
        parent_wrapper: parent_wrapper,
        table_scroll_behavior: 'overflow-y-scroll h-3/4 w-full',
        table_header_styling: 'bg-neutral-200 text-center',
        table_heading: 'mt-0 mb-4',

        table_body_styling: {
          row_border: 'border border-dashed border-red-500',
          index_styling: 'border-x border-dashed border-red-500 p-0.5 px-1 text-center w-2',
          name_styling: ' px-1 max-w-20 overflow-hidden truncate whitespace-nowrap text-ellipsis',
          keyword_styling: ' px-1 w-5 overflow-hidden truncate whitespace-nowrap text-ellipsis '
        }

      },
      include: {
        kw_count: true
      }
    }
  end

  def project_id_insights_table
    {
      title: 'URLs',
      columns: ['#', 'URL', 'SV', 'Est Traffic', 'KW Count'],
      urls: @top_urls,
      entry_key: 'name',
      styling: {
        parent_wrapper: parent_wrapper,
        table_header_styling: 'text-red-500 text-sm bg-white ',
        table_scroll_behavior: 'overflow-y-scroll w-full flex-1 h-3/4 max-h-60',
        overflow: 'overflow-y-scroll ',
        table_body_styling: table_body_styling
      },

      include: {
        traffic: true,
        kw_count: true
      }
    }
  end

  def project_id_category_table
    {
      title: 'Categories',
      columns: ['#', 'Category', 'Volume', 'Est. Traffic', 'KW Count'],
      entries: @top_categories,
      entry_key: 'name',
      styling: {
        parent_wrapper: parent_wrapper,
        table_header_styling: 'text-red-500 text-sm bg-white ',
        table_scroll_behavior: 'overflow-y-scroll w-full flex-1  h-3/4 max-h-60',
        overflow: 'overflow-y-scroll ',
        table_body_styling: table_body_styling
      },
      table_primary_field: 'url'

    }
  end

  def project_id_ngram_table
    {
      title: 'Phrases',
      columns: ['#', 'Phrase', 'Weighted Freq.', 'Count'],
      entries: @ngrams,
      entry_key: 'phrase',
      styling: {
        parent_wrapper: parent_wrapper,
        table_header_styling: 'text-red-500 text-sm bg-white ',
        table_scroll_behavior: 'overflow-y-scroll w-full flex-1 h-3/4 max-h-65',
        overflow: 'overflow-y-scroll ',
        table_body_styling: table_body_styling

      },
      table_primary_field: 'url',
      include: {
        kw_count: true
      }

    }
  end

  def project_index_summary
    {
      title: 'Projects by The Numbers',
      columns: [],
      entry_key: 'keyword_count',
      styling: {
        parent_wrapper: 'bg-zinc-500 row-span-3 col-span-2 text-left font-medium text-white max-h-300 mt-4 px-5 rounded-sm shadow-md',
        table_scroll_behavior: 'overflow-y-scroll max-h-150',
        table_header_styling: 'nil',

        table_body_styling: {
          row_border: 'border border-dashed border-red-500',
          index_styling: 'border-x border-dashed border-red-500 p-0.5 px-1 text-center w-2',
          name_styling: ' px-1 max-w-20 overflow-hidden truncate whitespace-nowrap text-ellipsis',
          keyword_styling: ' px-5 w-5 overflow-hidden truncate whitespace-nowrap text-ellipsis '
        }

      },
      include: {
        kw_count: true
      }
    }
  end

  def kw_columns
    ['#', 'Keyword', 'Search Volume']
  end

  def project_columns
    ['#', 'Name', 'Insight']
  end

  def glass_red_chart_options
    {
      colors: ['#FF4D4D', '#FFD1D1', '#FF8888', '#FF9999'],
      height: '100',
      library: {
        # this is Chart.js "options" (no extra :options wrapper)
        responsive: true,
        maintainAspectRatio: false,
        backgroundColor: 'rgba(0,255,255,0.4)', # slightly glassy
        plugins: {
          title: {
            fullSize: false,
            font: { size: 14 }
          },
          datalabels: {
            display: true,
            anchor: 'end',
            align: 'top',
            color: 'rgba(255,255,255,0.9)',
            font: { size: 14, family: 'Inter', weight: '600' },
            formatter: ->(value) { value } # shows count value on top of each bar
          },
          legend: {
            display: false
            # If you later enable legend and want spacing:
            # labels: { boxPadding: 4 }
          },

          tooltip: {
            backgroundColor: 'rgba(255, 255, 255, 0.85)',
            borderColor: 'rgba(255, 77, 77, 0.3)',
            borderWidth: 1,
            titleColor: '#FF4D4D',
            bodyColor: '#444',
            titleFont: { size: 16, weight: '300' },
            bodyFont: { size: 12 },
            cornerRadius: 6,
            padding: 8
          }
        },
        maxBarThickness: 50,

        scales: {
          x: { display: true,
               title: { display: true },
               grid: { color: 'rgba(255, 255, 255, 0.05)' } },
          y: {
            ticks: {
              color: 'rgba(255, 255, 255, 0.8)',
              font: { size: 16 }
            },
            grid: { color: 'rgba(255, 255, 255, 0.08)' }

          }
        }
      }
    }
  end

  def glass_red_pie_options
    {
      colors: [
        '#FF4D4D', '#e5b443', '#a1a1aa', '#FFD1D1',
        '#d9a23a', '#FF8888', '#FF9999', '#f1cb4b'
      ],
      library: {
        type: 'pie', # Let Chartkick know the chart type
        options: {
          responsive: true,
          backgroundColor: '#ffffff',
          plugins: {
            tooltip: {
              backgroundColor: 'rgba(255, 255, 255, 0.85)',
              borderColor: 'rgba(255, 77, 77, 0.3)',
              borderWidth: 1,
              titleColor: '#FF4D4D',
              bodyColor: '#444',
              titleFont: {
                size: 14,
                weight: '600'
              },
              bodyFont: {
                size: 12
              },
              cornerRadius: 6,
              boxPadding: 4
            }
          }
        },
        overrides: {
          pie: {
            plugins: {
              legend: {
                display: true,
                position: 'left',
                align: 'start',
                labels: {
                  boxWidth: 30,
                  padding: 10,
                  color: '#333',
                  font: {
                    size: 14,
                    family: 'Inter'
                  }
                }
              }
            }
          }
        }
      }
    }
  end
end
