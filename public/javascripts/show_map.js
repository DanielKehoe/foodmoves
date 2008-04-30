/*
 * Ext JS Library 1.1 Beta 1
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://www.extjs.com/license
 */

// make the tabs variable global so it can accessed anywhere
var tabs;

var TabsExample = {
    init : function(){
        tabs = new Ext.TabPanel('tabs1');
        tabs.addTab('list', "List");
        tabs.addTab('map', "Map");
        tabs.activate('map');
    }
}
Ext.EventManager.onDocumentReady(TabsExample.init, TabsExample, true);
