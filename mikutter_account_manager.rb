#-*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), 'account_manager'))

Plugin.create :mikutter_account_manager do

  filter_gui_postbox_post do |gui_postbox|

    text = Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text

    if text =~ /^AccountManager(::|\.)[a-zA-Z_]+/
      begin
        Kernel.instance_eval(text)
        Plugin.call(:before_postbox_post,
                    Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text)
        Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text = ''
      rescue Exception => e
        Plugin.call(:update, nil, [Message.new(message: e.to_s, system: true)])
        e.backtrace
      end
      Plugin.filter_cancel!
    end

    [gui_postbox]
  end

end
