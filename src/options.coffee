Options =
  init: ->
    unless $.get 'firstrun'
      $.set 'firstrun', true
      # Prevent race conditions
      Favicon.init() unless Favicon.el
      Options.dialog()
    for settings in ['navtopright', 'navbotright']
      a = $.el 'a',
        href: 'javascript:;'
        className: 'settingsWindowLink'
        textContent: 'AppChan X Settings'
      $.on a, 'click', ->
        Options.dialog()
        if Conf['Style']
          Style.allrice()
      $.prepend $.id(settings), [$.tn('['), a, $.tn('] ')]

  dialog: (tab) ->
    if editMode
      if confirm "Opening the options dialog will close and discard any theme changes made with the theme editor."
        try ThemeTools.close()
        try MascotTools.close()
        editMode = false
      else
        return
    dialog = $.el 'div'
      id: 'options'
      className: 'reply dialog'
      innerHTML: '<div id=optionsbar>
  <div id=credits>
    <label for=apply>Apply</label>
    | <a target=_blank href=http://zixaphir.github.com/appchan-x/>AppChan X</a>
    | <a target=_blank href=https://raw.github.com/zixaphir/appchan-x/master/changelog>' + Main.version + '</a>
    | <a target=_blank href=http://zixaphir.github.com/appchan-x/#bug-report>Issues</a>
  </div>
  <div>
    <label for=main_tab>Main</label>
    | <label for=filter_tab>Filter</label>
    | <label for=sauces_tab>Sauce</label>
    | <label for=rice_tab>Rice</label>
    | <label for=keybinds_tab>Keybinds</label>
    | <label for=style_tab>Style</label>
    | <label for=theme_tab>Themes</label>
    | <label for=mascot_tab>Mascots</label>
  </div>
</div>
<hr>
<div id=content>
  <input type=radio name=tab hidden id=main_tab checked>
  <div></div>
  <input type=radio name=tab hidden id=sauces_tab>
  <div>
    <div class=warning><code>Sauce</code> is disabled.</div>
    Lines starting with a <code>#</code> will be ignored.<br>
    You can specify a certain display text by appending <code>;text:[text]</code> to the url.
    <ul>These parameters will be replaced by their corresponding values:
      <li>$1: Thumbnail url.</li>
      <li>$2: Full image url.</li>
      <li>$3: MD5 hash.</li>
      <li>$4: Current board.</li>
    </ul>
    <textarea name=sauces id=sauces class=field></textarea>
  </div>
  <input type=radio name=tab hidden id=filter_tab>
  <div>
    <div class=warning><code>Filter</code> is disabled.</div>
    <select name=filter>
      <option value=guide>Guide</option>
      <option value=name>Name</option>
      <option value=uniqueid>Unique ID</option>
      <option value=tripcode>Tripcode</option>
      <option value=mod>Admin/Mod</option>
      <option value=email>E-mail</option>
      <option value=subject>Subject</option>
      <option value=comment>Comment</option>
      <option value=country>Country</option>
      <option value=filename>Filename</option>
      <option value=dimensions>Image dimensions</option>
      <option value=filesize>Filesize</option>
      <option value=md5>Image MD5 (uses exact string matching, not regular expressions)</option>
    </select>
  </div>
  <input type=radio name=tab hidden id=rice_tab>
  <div>
    <div class=warning><code>Quote Backlinks</code> are disabled.</div>
    <ul>
      Backlink formatting
      <li><input name=backlink class=field> : <span id=backlinkPreview></span></li>
    </ul>
    <div class=warning><code>Time Formatting</code> is disabled.</div>
    <ul>
      Time formatting
      <li><input name=time class=field> : <span id=timePreview></span></li>
      <li>Supported <a href=http://en.wikipedia.org/wiki/Date_%28Unix%29#Formatting>format specifiers</a>:</li>
      <li>Day: %a, %A, %d, %e</li>
      <li>Month: %m, %b, %B</li>
      <li>Year: %y</li>
      <li>Hour: %k, %H, %l (lowercase L), %I (uppercase i), %p, %P</li>
      <li>Minutes: %M</li>
      <li>Seconds: %S</li>
    </ul>
    <div class=warning><code>File Info Formatting</code> is disabled.</div>
    <ul>
      File Info Formatting
      <li><input name=fileInfo class=field> : <span id=fileInfoPreview class=fileText></span></li>
      <li>Link (with original file name): %l (lowercase L, truncated), %L (untruncated)</li>
      <li>Original file name: %n (Truncated), %N (Untruncated)</li>
      <li>Spoiler indicator: %p</li>
      <li>Size: %B (Bytes), %K (KB), %M (MB), %s (4chan default)</li>
      <li>Resolution: %r (Displays PDF on /po/, for PDFs)</li>
    </ul>
    <div class=warning><code>Unread Favicon</code> is disabled.</div>
    Unread favicons<br>
    <select name=favicon>
      <option value=ferongr>ferongr</option>
      <option value=xat->xat-</option>
      <option value=Mayhem>Mayhem</option>
      <option value=Original>Original</option>
    </select>
    <span></span>
  </div>
  <input type=radio name=tab hidden id=keybinds_tab>
  <div>
    <div class=warning><code>Keybinds</code> are disabled.</div>
    <div>Allowed keys: Ctrl, Alt, Meta, a-z, A-Z, 0-9, Up, Down, Right, Left.</div>
    <table><tbody>
      <tr><th>Actions</th><th>Keybinds</th></tr>
    </tbody></table>
  </div>
  <input type=radio name=tab hidden id=style_tab>
  <div></div>
  <input type=radio name=tab hidden id=theme_tab>
  <div></div>
  <input type=radio name=tab hidden id=mascot_tab>
  <div></div>
  <input type=radio name=tab hidden onClick="javascript:location.reload(true)" id=apply>
  <div>Reloading page with new settings.</div>
</div>'

    #main
    for key, obj of Config.main
      ul = $.el 'ul',
        textContent: key
      for key, arr of obj
        checked = if $.get(key, Conf[key]) then 'checked' else ''
        description = arr[1]
        li = $.el 'li',
          innerHTML: "<label><input type=checkbox name=\"#{key}\" #{checked}><span class=\"optionlabel\">#{key}</span></label><span class=description>: #{description}</span>"
        $.on $('input', li), 'click', $.cb.checked
        $.add ul, li
      $.add $('#main_tab + div', dialog), ul

    hiddenThreads = $.get "hiddenThreads/#{g.BOARD}/", {}
    hiddenNum = Object.keys(g.hiddenReplies).length + Object.keys(hiddenThreads).length
    li = $.el 'li',
      innerHTML: "<button>hidden: #{hiddenNum}</button> <span class=description>: Forget all hidden posts. Useful if you accidentally hide a post and have \"Show Stubs\" disabled."
    $.on $('button', li), 'click', Options.clearHidden
    $.add $('ul:nth-child(2)', dialog), li

    #filter
    filter = $ 'select[name=filter]', dialog
    $.on filter, 'change', Options.filter

    #sauce
    sauce = $ '#sauces', dialog
    sauce.value = $.get sauce.name, Conf[sauce.name]
    $.on sauce, 'change', $.cb.value

    #rice
    (back     = $ '[name=backlink]', dialog).value = $.get 'backlink', Conf['backlink']
    (time     = $ '[name=time]',     dialog).value = $.get 'time',     Conf['time']
    (fileInfo = $ '[name=fileInfo]', dialog).value = $.get 'fileInfo', Conf['fileInfo']
    $.on back,     'input', $.cb.value
    $.on back,     'input', Options.backlink
    $.on time,     'input', $.cb.value
    $.on time,     'input', Options.time
    $.on fileInfo, 'input', $.cb.value
    $.on fileInfo, 'input', Options.fileInfo
    favicon = $ 'select[name=favicon]', dialog
    favicon.value = $.get 'favicon', Conf['favicon']
    $.on favicon, 'change', $.cb.value
    $.on favicon, 'change', Options.favicon

    #keybinds
    for key, arr of Config.hotkeys
      tr = $.el 'tr',
        innerHTML: "<td>#{arr[1]}</td><td><input name=#{key} class=field></td>"
      input = $ 'input', tr
      input.value = $.get key, Conf[key]
      $.on input, 'keydown', Options.keybind
      $.add $('#keybinds_tab + div tbody', dialog), tr

    #style
    div = $.el 'div',
      className: "suboptions"
      innerHTML: "<div class=warning><code>Style</code> is currently disabled. Please enable it in the Main tab to use styling options.</div>"
    for category, obj of Config.style
      ul = $.el 'ul',
        textContent: category
      for optionname, arr of obj
        description = arr[1]
        if arr[2] == 'text'
          li = $.el 'li',
          innerHTML: "<label><span class=\"optionlabel\">#{optionname}</span></label><span class=description>: #{description}</span><input name=\"#{optionname}\" style=\"width: 100%\"><br>"
          styleSetting = $ "input[name='#{optionname}']", li
          styleSetting.value = $.get optionname, Conf[optionname]
          $.on styleSetting, 'change', $.cb.value
          $.on styleSetting, 'change', Options.style
        else if arr[2]
          liHTML = "
          <label><span class=\"optionlabel\">#{optionname}</span></label><span class=description>: #{description}</span><select name=\"#{optionname}\"><br>"
          for selectoption, optionvalue in arr[2]
            liHTML = liHTML + "<option value=\"#{selectoption}\">#{selectoption}</option>"
          liHTML = liHTML + "</select>"
          li = $.el 'li',
            innerHTML: liHTML
          styleSetting = $ "select[name='#{optionname}']", li
          styleSetting.value = $.get optionname, Conf[optionname]
          $.on styleSetting, 'change', $.cb.value
          $.on styleSetting, 'change', Options.style
        else
          checked = if $.get(optionname, Conf[optionname]) then 'checked' else ''
          li = $.el 'li',
            innerHTML: "<label><input type=checkbox name=\"#{optionname}\" #{checked}><span class=\"optionlabel\">#{optionname}<span></label><span class=description>: #{description}</span>"
          $.on $('input', li), 'click', $.cb.checked
        $.add ul, li
      $.add div, ul
    $.add $('#style_tab + div', dialog), div
    Options.applyStyle(dialog, 'style_tab')

    #themes
    @themeTab dialog

    #mascots
    parentdiv = $.el 'div',
      className: "suboptions"
      innerHTML: "<div class=warning><code>Style</code> is currently disabled. Please enable it in the Main tab to use mascot options.</div>"
    ul = $.el 'ul',
      className:   'mascots'
    for name, mascot of userMascots
      unless mascot["Deleted"]
        description = name
        li = $.el 'li',
          className: 'mascot'
          innerHTML: "
<div id='#{name}' class='#{mascot.category}' style='background-image: url(#{mascot.image});'></div>
<span class='mascotoptions'><a class=edit name='#{name}' href='javascript:;'>Edit</a> / <a class=delete name='#{name}' href='javascript:;'>Delete</a></span>
"
        $.on $('a.edit', li), 'click', ->
          unless Conf["Style"]
            alert "Please enable Style Options and reload the page to use Mascot Tools."
            return
          MascotTools.dialog @name
          Options.close()
        $.on $('a.delete', li), 'click', ->
          container = @.parentElement.parentElement
          if confirm "Are you sure you want to delete \"#{@name}\"?"
            if enabledmascots[@name]
              enabledmascots[@name] = false
              $.set @name, false
            userMascots[@name]["Deleted"] = true
            $.set "userMascots", userMascots
            $.rm container
        div = $('div', li)
        if enabledmascots[name] == true
          $.addClass div, 'enabled'
        $.on div, 'click', ->
          if enabledmascots[@.id] == true
            $.rmClass @, 'enabled'
            $.set @.id, false
            enabledmascots[@.id] = false
          else
            $.addClass @, 'enabled'
            $.set @.id, true
            enabledmascots[@.id] = true
        $.add ul, li
        $.add parentdiv, ul
    $.add $('#mascot_tab + div', dialog), parentdiv
    batchmascots = $.el 'div',
      id:        "mascots_batch"
      innerHTML: "<a href=\"javascript:;\" id=\"clear\">Clear All</a> / <a href=\"javascript:;\" id=\"selectAll\">Select All</a> / <a href=\"javascript:;\" id=\"createNew\">New Mascot</a>"
    $.on $('#clear', batchmascots), 'click', ->
      for mascotname, mascot of enabledmascots
        if enabledmascots[mascotname] == true
          $.rmClass $('#' + mascotname, @parentElement.parentElement), 'enabled'
          $.set mascotname, false
          enabledmascots[mascotname] = false
    $.on $('#selectAll', batchmascots), 'click', ->
      for mascotname, mascot of enabledmascots
        if $.get(mascotname, false) == false and not userMascots[mascotname]["Deleted"]
          $.addClass $('#' + mascotname, @parentElement.parentElement), 'enabled'
          $.set mascotname, true
          enabledmascots[mascotname] = true
    $.on $('#createNew', batchmascots), 'click', ->
      unless Conf["Style"]
        alert "Please enable Style Options and reload the page to use Mascot Tools."
        return
      MascotTools.dialog()
      Options.close()
    $.add $('#mascot_tab + div', dialog), batchmascots
        
    Options.applyStyle(dialog, 'mascot_tab')

    Options.indicators dialog
    
    if tab
      $("#main_tab", dialog).checked = false
      $("#" + tab + "_tab", dialog).checked = true

    overlay = $.el 'div', id: 'overlay'
    $.on overlay, 'click', Options.close
    $.add d.body, overlay
    dialog.style.visibility = 'hidden'
    $.add d.body, dialog
    dialog.style.visibility = 'visible'

    Options.filter.call   filter
    Options.backlink.call back
    Options.time.call     time
    Options.fileInfo.call fileInfo
    Options.favicon.call  favicon
    

  indicators: (dialog) ->
    indicators = {}
    for indicator in $$ '.warning', dialog
      key = indicator.firstChild.textContent
      indicator.hidden = $.get key, Conf[key]
      indicators[key] = indicator
      $.on $("[name='#{key}']", dialog), 'click', ->
        indicators[@name].hidden = @checked
    for indicator in $$ '.disabledwarning', dialog
      key = indicator.firstChild.textContent
      indicator.hidden = not $.get key, Conf[key]
      indicators[key] = indicator
      $.on $("[name='#{key}']", dialog), 'click', ->
        Options.indicators dialog

        
  themeTab: (dialog) ->
    unless dialog
      dialog = $("#options", d.body)
    parentdiv = $.el 'div',
      className: "suboptions"
      id:        "themes"
      innerHTML: "<div class=warning><code>Style</code> is currently disabled. Please enable it in the Main tab to use theming options.</div>"
    for themename, theme of userThemes
      unless theme["Deleted"]
        div = $.el 'div',
          className: if themename == Conf['theme'] then 'selectedtheme replyContainer' else 'replyContainer'
          id:        themename
          innerHTML: "
<div class='reply' style='position: relative; width: 100%; box-shadow: none !important; background-color:#{theme['Reply Background']}!important;border:1px solid #{theme['Reply Border']}!important;color:#{theme['Text']}!important'>
  <div class='rice' style='cursor: pointer; width: 12px;height: 12px;margin: 0 3px;vertical-align: middle;display: inline-block;background-color:#{theme['Checkbox Background']};border: 1px solid #{theme['Checkbox Border']};'></div>
  <span style='color:#{theme['Subjects']}!important; font-weight: 700 !important'> #{themename}</span> 
  <span style='color:#{theme['Names']}!important; font-weight: 700 !important'> #{theme['Author']}</span>
  <span style='color:#{theme['Sage']}!important'> (SAGE)</span>
  <span style='color:#{theme['Tripcodes']}!important'> #{theme['Author Tripcode']}</span>
  <time style='color:#{theme['Timestamps']}'> 20XX.01.01 12:00 </time>
  <a onmouseout='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Post Numbers']}!important&quot;)' onmouseover='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Hovered Links']}!important&quot;)' style='color:#{theme['Post Numbers']}!important;' href='javascript:;'>No.27583594</a>
  <a class=edit name='#{themename}' onmouseout='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Backlinks']}!important; font-weight: 800;&quot;)' onmouseover='this.setAttribute(&quot;style&quot;,&quot; font-weight: 800;color:#{theme['Hovered Links']}!important;&quot;)' style='color:#{theme['Backlinks']}!important; font-weight: 800;' href='javascript:;'> &gt;&gt;edit</a>
  <a class=export name='#{themename}' onmouseout='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Backlinks']}!important; font-weight: 800;&quot;)' onmouseover='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Hovered Links']}!important; font-weight: 800;&quot;)' style='color:#{theme['Backlinks']}!important; font-weight: 800;' href='javascript:;'> &gt;&gt;export</a>
  <a class=delete onmouseout='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Backlinks']}!important; font-weight: 800;&quot;)' onmouseover='this.setAttribute(&quot;style&quot;,&quot;color:#{theme['Hovered Links']}!important; font-weight: 800;&quot;)' style='color:#{theme['Backlinks']}!important; font-weight: 800;' href='javascript:;'> &gt;&gt;delete</a>
  <br>
  <blockquote style='cursor: pointer; margin: 0; padding: 12px 40px'>
    <a style='color:#{theme['Quotelinks']}!important; font-weight: 800;'>&gt;&gt;27582902</a>
    <br>
    Post content is right here.
  </blockquote>
  <h1 style='color: #{theme['Text']}'>Selected</h1>
</div>"
        $.on $('a.edit', div), 'click', ->
          unless Conf["Style"]
            alert "Please enable Style Options and reload the page to use Theme Tools."
            return
          ThemeTools.init @.name
          Options.close()
        $.on $('a.export', div), 'click', ->
          exportTheme = userThemes[@.name]
          exportTheme['Theme'] = @.name
          exportedTheme = "data:application/json," + encodeURIComponent(JSON.stringify(exportTheme))
          if window.open exportedTheme, "_blank"
            return
          else if confirm "Your popup blocker is preventing Appchan X from exporting this theme. Would you like to open the exported theme in this window?"
            window.location exportedTheme
        $.on $('a.delete', div), 'click', ->
          container = @.parentElement.parentElement
          unless container.previousSibling or container.nextSibling
            alert "Cannot delete theme (No other themes available)."
            return
          if confirm "Are you sure you want to delete \"#{container.id}\"?"
            if container.id == Conf['theme']
              if settheme = container.previousSibling or container.nextSibling
                Conf['theme'] = settheme.id
                $.addClass settheme, 'selectedtheme'
                $.set 'theme', Conf['theme']
            userThemes[container.id]["Deleted"] = true
            $.set 'userThemes', userThemes
            $.rm container
        $.on $('.rice', div), 'click', Options.selectTheme
        $.on $('blockquote', div), 'click', Options.selectTheme
        $.add parentdiv, div
    div = $.el 'div',
      id:        'addthemes'
      innerHTML: "<a id=import href='javascript:;'>Import Theme</a><input type=file hidden> / <a id=newtheme href='javascript:;'>New Theme</a>"
    $.on $("#import", div), 'click', ->
      @nextSibling.click()
    $.on $("#newtheme", div), 'click', ->
      unless Conf["Style"]
        alert "Please enable Style Options and reload the page to use Theme Tools."
        return
      newTheme = true
      ThemeTools.init "untitled"
      Options.close()
    $.on $("input", div), 'change', (evt) ->
      file = evt.target.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        try
          theme = JSON.parse e.target.result
        catch err
          alert err
          return
        unless theme["Author Tripcode"]
          alert "Theme file is invalid."
          return
        name = theme["Theme"]
        delete theme["Theme"]
        if userThemes[name] and not userThemes[name]["Deleted"]
          if confirm "A theme with this name already exists. Would you like to over-write?"
            delete userThemes[name]
          else
            return
        userThemes[name] = theme
        $.set 'userThemes', userThemes
        alert "Theme \"#{name}\" imported!"
        $.rm $("#themes", d.body)
        Options.themeTab()
      reader.readAsText(file);
    $.add $('#theme_tab + div', dialog), parentdiv
    $.add $('#theme_tab + div', dialog), div
    Options.applyStyle(dialog, 'theme_tab')

  close: ->
    $.rm $('#options', d.body)
    $.rm $('#overlay', d.body)

  clearHidden: ->
    #'hidden' might be misleading; it's the number of IDs we're *looking* for,
    # not the number of posts actually hidden on the page.
    $.delete "hiddenReplies/#{g.BOARD}/"
    $.delete "hiddenThreads/#{g.BOARD}/"
    @textContent = "hidden: 0"
    g.hiddenReplies = {}
  keybind: (e) ->
    return if e.keyCode is 9
    e.preventDefault()
    e.stopPropagation()
    return unless (key = Keybinds.keyCode e)?
    @value = key
    $.cb.value.call @
  filter: ->
    el = @nextSibling

    if (name = @value) isnt 'guide'
      ta = $.el 'textarea',
        name: name
        className: 'field'
        value: $.get name, Conf[name]
      $.on ta, 'change', $.cb.value
      $.replace el, ta
      return

    $.rm el if el
    $.after @, $.el 'article',
      innerHTML: '<p>Use <a href=https://developer.mozilla.org/en/JavaScript/Guide/Regular_Expressions>regular expressions</a>, one per line.<br>
  Lines starting with a <code>#</code> will be ignored.<br>
  For example, <code>/weeaboo/i</code> will filter posts containing the string `<code>weeaboo</code>`, case-insensitive.</p>
  <ul>You can use these settings with each regular expression, separate them with semicolons:
    <li>
      Per boards, separate them with commas. It is global if not specified.<br>
      For example: <code>boards:a,jp;</code>.
    </li>
    <li>
      Filter OPs only along with their threads (`only`), replies only (`no`, this is default), or both (`yes`).<br>
      For example: <code>op:only;</code>, <code>op:no;</code> or <code>op:yes;</code>.
    </li>
    <li>
      Overrule the `Show Stubs` setting if specified: create a stub (`yes`) or not (`no`).<br>
      For example: <code>stub:yes;</code> or <code>stub:no;</code>.
    </li>
    <li>
      Highlight instead of hiding. You can specify a class name to use with a userstyle.<br>
      For example: <code>highlight;</code> or <code>highlight:wallpaper;</code>.
    </li>
    <li>
      Highlighted OPs will have their threads put on top of board pages by default.<br>
      For example: <code>top:yes;</code> or <code>top:no;</code>.
    </li>
  </ul>'
  time: ->
    Time.foo()
    Time.date = new Date()
    $.id('timePreview').textContent = Time.funk Time
  backlink: ->
    $.id('backlinkPreview').textContent = Conf['backlink'].replace /%id/, '123456789'
  fileInfo: ->
    FileInfo.data =
      link:       'javascript:;'
      spoiler:    true
      size:       '276'
      unit:       'KB'
      resolution: '1280x720'
      fullname:   'd9bb2efc98dd0df141a94399ff5880b7.jpg'
      shortname:  'd9bb2efc98dd0df141a94399ff5880(...).jpg'
    FileInfo.setFormats()
    $.id('fileInfoPreview').innerHTML = FileInfo.funk FileInfo
  favicon: ->
    Favicon.switch()
    Unread.update true
    @nextElementSibling.innerHTML = "<img src=#{Favicon.unreadSFW}> <img src=#{Favicon.unreadNSFW}> <img src=#{Favicon.unreadDead}>"

  applyStyle: (dialog, tab) ->
    if Conf['styleenabled'] == '1'
      save = $.el 'div',
        innerHTML: '<a href="javascript:;">Save Style Settings</a>'
        className: 'stylesettings'
      $.on $('a', save), 'click', ->
        Style.addStyle()
      $.add $('#' + tab + ' + div', dialog), save
  
  selectTheme: ->  
    container = @.parentElement.parentElement
    if currentTheme = $.id(Conf['theme'])
      $.rmClass currentTheme, 'selectedtheme'
    $.set 'theme', container.id
    Conf['theme'] = container.id
    $.addClass container, 'selectedtheme'