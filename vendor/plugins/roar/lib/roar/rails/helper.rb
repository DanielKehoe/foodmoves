module Roar::Rails
  module Helper
    def roar_column(column, record)
      render(:partial => roar_path("columns/#{column.type}", :partial=>true, :view=>column.view), 
       :locals=>{:record=>record, :column=>column})
    end

    def roar_table(options = {})
      table = roar.table(options)
      render(:partial => roar_path("table", :partial=>true, :view => table.view), :locals=>{:table=>table})
    end
    
    def roar_field(field, form, record)
      render(:partial => roar_path("fields/#{field.type}", :partial => true, :view => field.view), 
        :locals=>{:field=>field, :form=>form, :record=>record})
    end
    
    def roar_filter(filter, form)
      render(:roar_partial => "filters/#{filter.type}", :locals=>{:name=>filter.name, :form=>form, :filter=>filter})
    end
    
    def roar_form(record, options={}, &block)
      form = Roar::Form.new(record, options, &block)
      render(:partial => roar_path("form", :partial => true, :view => form.view), 
        :locals=>{:record=>record, :form=>form})
    end
        
    def form_field(field, record, options = {}, &block)
      options.merge!(:body=>capture(&block), :field=>field, :record=>record)
      concat(render(:partial => roar_path("fields/field", :partial=>true, :view=>field.view), 
       :locals=>options), block.binding)
    end
    
    # hmmm
    def admin_paginator_links(pager, page, options={})
      options = {:always_show_anchors=>true, :window_size=>2}.merge(options)
      window_start = page.number - options[:window_size]
      window_start = 1 if window_start <= 0
      window_end = window_start + options[:window_size]*2
      if window_end > pager.last.number then
        window_start = [pager.last.number - options[:window_size]*2, window_start].min
        window_end = pager.last.number
      end
      if window_start > 1 and options[:always_show_anchors] then
        yield pager.first
        if window_start > 2 then
          yield nil
        end
      end
      pager.each do |p|
        if p.number >= window_start and p.number <= window_end then
          yield p
        end
      end
      if window_end < pager.last.number and options[:always_show_anchors] then
        if window_end < pager.last.number - 1 then
          yield nil
        end
        yield pager.last
      end
    end
  end
end
