# Data formatting helper methods
module DataFormatHelper
  
  # Convert view to search path for the backend
  def view_to_path(view)
    prefix = ""
    suffix = "hits"
    if view == 2 || view == 16
      suffix = "docs"
    end
    if WhitelabBackend.instance.get_backend_type.eql?('neo4j') && (view == 8 || view == 16)
      prefix = "grouped_"
    end
    prefix+suffix
  end

  # Convert group to correct value
  def group_to_label(group)
    if group.eql?('text')
      'word'
    else
      group
    end
  end

  # Get translation key for a specific metadata group
  def group_translation_key(group)
    :"metadata_groups.keys.#{group}"
  end

  # Get translation key for a specific metadata key
  def key_translation_key(key)
    :"metadata_keys.keys.#{key}"
  end
  
  # Format percentage
  def format_percentage(pro,d)
    pro.round(d).to_s+" %"
  end
  
  # Format corpus composition as Highcharts bubble chart
  def format_for_bubble_chart(data, title, filtered_token_count)
    max_doc_count = 0
    total_doc_count = 0
    if data.any?
      data.sort!{|group| group['document_count'] }
      max_doc_count = data[0]['document_count']
      data.each{|group| total_doc_count += group['document_count'] }
      data.map!{|group| {
        'name' => group[title].length > 0 ? group[title] : "Unknown",
        'x' => group['hit_count'],
        'x2' => ActionController::Base.helpers.number_with_precision((group['hit_count'].to_f / filtered_token_count) * 100, precision: 1, separator: t(:"other.keys.numeric_separator")),
        'y' => group['hit_count'] / group['document_count'],
        'z' => group['document_count'],
        'z2' => ActionController::Base.helpers.number_with_precision((group['document_count'].to_f / total_doc_count) * 100, precision: 1, separator: t(:"other.keys.numeric_separator")) }
      }
    else
      data = [{ 'name' => 'Unknown', 'x' => filtered_token_count, 'y' => 0, 'z' => 0 }]
    end
    return { "title" => t(:"chart_labels.keys.bubble_title"), "x-title" => t(:"chart_labels.keys.bubble_x_title"), "y-title" => t(:"chart_labels.keys.bubble_y_title"), "z-title" => t(:"chart_labels.keys.bubble_z_title"), "unit" => t(:"chart_labels.keys.bubble_unit"), "data" => data, "max_doc_count" => max_doc_count }
  end
  
  # Format corpus composition as Highcharts treemap
  def format_for_treemap(data, title, filtered_token_count)
    if data.any?
      data.map!{|group| { 'name' => group[title].length > 0 ? group[title] : "Unknown", 'size' => group['hit_count'] } }
    else
      data = [{ 'name' => 'Unknown', 'size' => 0 }]
    end
    return { 'name' => title, 'size' => filtered_token_count, 'children' => data }
  end
  
  # Convert timestamp to seconds
  def time_to_seconds(t)
    parts = t.split(":");
    parts[2].to_f + (60 * parts[1].to_i) + (3600 * parts[0].to_i)
  end
  
  # Convert operator to value string
  def operator_to_value(op)
    if op.eql?('!=')
      return 'not'
    end
    'is'
  end
  
  # Convert array of hashes to CSV with header row
  def aoh_to_csv(aoh)
    csv = []
    csv << aoh[0].keys.join(",")
    aoh.each do |row|
      if !row.blank?
        data = []
        aoh[0].keys.each do |key|
          data << row[key]
        end
        csv << '"'+data.join('","')+'"'
      end
    end
    csv.join("\n")
  end
  
end