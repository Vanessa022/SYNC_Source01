sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","sync/zca11demo2/model/models"],function(e,t,i){"use strict";return e.extend("sync.zca11demo2.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init.apply(this,arguments);this.getR+
outer().initialize();this.setModel(i.createDeviceModel(),"device")}})});                                                                                                                                                                                       