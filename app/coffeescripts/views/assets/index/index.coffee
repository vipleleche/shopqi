App.Views.Asset.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #save-button": 'save'
    "click #asset-link-rollback a": 'versions'
    "click #asset-rollback-form a": 'cancelRollback'
    "change #asset-rollback-form select": 'updateAsset'

  initialize: ->
    self = this
    this.render()
    this.templateEditor()

  render: ->
    _(@options.data).each (assets, name) ->
      collection = new App.Collections.Assets assets
      collection.each (asset) -> new App.Views.Asset.Index.Show model: asset, name: name

  save: ->
    model = TemplateEditor.current
    value = TemplateEditor.editor.getSession().getValue()
    $('#asset-info').html("正在保存 #{model.get('name')} &hellip;").show()
    $.post '/admin/themes/assets', key: model.get('key'), value: value, ->
      $('#asset-info').html("您的文件已经保存.").fadeOut(5000)
      model.view.setModified false

  versions: ->
    model = TemplateEditor.current
    $.get '/admin/themes/versions', key: model.get('key'), (data) ->
      template = Handlebars.compile $('#rollback-selectbox-item').html()
      $('#asset-links').html template commits: data
    false

  updateAsset: ->
    model = TemplateEditor.current
    tree_id = $('#asset-rollback-form select').children('option:selected').attr('tree_id')
    $.get "/admin/themes/asset/#{tree_id}", key: model.get('key'), (data) ->
      editor = TemplateEditor.editor
      editor.getSession().setValue data
      editor.moveCursorTo(0,0)
    false

  cancelRollback: ->
    $('#asset-links').html $('#asset-link-rollback-item').html()
    false

  templateEditor: ->
    window.TemplateEditor =
      editor: null
      current: null # 当前编辑的主题文件实体对象
      html_mode: require("ace/mode/html").Mode
      css_mode: require("ace/mode/css").Mode
      js_mode: require("ace/mode/javascript").Mode
      UndoManager: require("ace/undomanager").UndoManager
      EditSession: require("ace/edit_session").EditSession
      text_extensions: [ 'wmls', 'csv', 'vsc', 'qxb', 'qxt', 'kml', 'rb', 'ltx', 'ps', 'sl', 'cc', 'qxd', 'fsc', 'shar', 'txt', 'coffee', 'cmd', 'php', 'liquid', 'xpm', 't', 'js', 'imagemap', 'csh', 'roff', 'html', 'htmlx', 'texinfo', 'cpp', 'htm', 'bat', 'vcs', 'atc', 'smi', 'c', 'phtml', 'py', 'pht', 'xslt', 'rtx', 'ai', 'tex', 'hqx', 'ccc', 'dat', 'xmt_txt', 'svg', 'xlsx', 'dtd', 'troff', 'eps', 'hpp', 'xps', 'qwt', 'shtml', 'atom', 'h', 'xhtml', 'xsl', 'qxl', 'man', 'vcf', 'x_t', 'hlp', 'pl', 'rhtml', 'qwd', 'xbm', 'wml', 'eol', 'sgm', 'json', 'rst', 'htc', 'etx', 'hh', 'xml', 'm4u', 'yaml', 'eml', 'kmz', 'tcl', 'yml', 'texi', 'asc', 'acutc', 'rbw', 'smil', 'rdf', 'imap', 'sh', 'mxu', 'tr', 'htx', 'css', 'si', 'jad', 'latex', 'tsv' ]
      image_extensions: [ 'jpg', 'gif', 'png', 'jpeg' ]
