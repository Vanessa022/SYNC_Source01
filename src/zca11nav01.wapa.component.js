sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","zca11nav01/model/models"],function(e,t,i){"use strict";return e.extend("zca11nav01.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init.apply(this,arguments);this.getRouter().in+
itialize();this.setModel(i.createDeviceModel(),"device")}})});                                                                                                                                                                                                 