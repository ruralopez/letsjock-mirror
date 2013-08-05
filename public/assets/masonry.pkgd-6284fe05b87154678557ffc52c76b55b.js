/*!
 * Masonry PACKAGED v3.1.0
 * Cascading grid layout library
 * http://masonry.desandro.com
 * MIT License
 * by David DeSandro
 */
/*!
 * getStyleProperty by kangax
 * http://perfectionkills.com/feature-testing-css-properties/
 */
/*jshint browser: true, strict: true, undef: true */
/*globals define: false */
(function(e){"use strict";function r(e){if(!e)return;if(typeof n[e]=="string")return e;e=e.charAt(0).toUpperCase()+e.slice(1);var r;for(var i=0,s=t.length;i<s;i++){r=t[i]+e;if(typeof n[r]=="string")return r}}var t="Webkit Moz ms Ms O".split(" "),n=document.documentElement.style;typeof define=="function"&&define.amd?define(function(){return r}):e.getStyleProperty=r})(window),function(e,t){"use strict";function i(e){var t=parseFloat(e),n=e.indexOf("%")===-1&&!isNaN(t);return n&&t}function o(){var e={width:0,height:0,innerWidth:0,innerHeight:0,outerWidth:0,outerHeight:0};for(var t=0,n=s.length;t<n;t++){var r=s[t];e[r]=0}return e}function u(e){function u(e){typeof e=="string"&&(e=document.querySelector(e));if(!e||typeof e!="object"||!e.nodeType)return;var u=r(e);if(u.display==="none")return o();var a={};a.width=e.offsetWidth,a.height=e.offsetHeight;var f=a.isBorderBox=!!t&&!!u[t]&&u[t]==="border-box";for(var l=0,c=s.length;l<c;l++){var h=s[l],p=u[h],d=parseFloat(p);a[h]=isNaN(d)?0:d}var v=a.paddingLeft+a.paddingRight,m=a.paddingTop+a.paddingBottom,g=a.marginLeft+a.marginRight,y=a.marginTop+a.marginBottom,b=a.borderLeftWidth+a.borderRightWidth,w=a.borderTopWidth+a.borderBottomWidth,E=f&&n,S=i(u.width);S!==!1&&(a.width=S+(E?0:v+b));var x=i(u.height);return x!==!1&&(a.height=x+(E?0:m+w)),a.innerWidth=a.width-(v+b),a.innerHeight=a.height-(m+w),a.outerWidth=a.width+g,a.outerHeight=a.height+y,a}var t=e("boxSizing"),n;return function(){if(!t)return;var e=document.createElement("div");e.style.width="200px",e.style.padding="1px 2px 3px 4px",e.style.borderStyle="solid",e.style.borderWidth="1px 2px 3px 4px",e.style[t]="border-box";var s=document.body||document.documentElement;s.appendChild(e);var o=r(e);n=i(o.width)===200,s.removeChild(e)}(),u}var n=document.defaultView,r=n&&n.getComputedStyle?function(e){return n.getComputedStyle(e,null)}:function(e){return e.currentStyle},s=["paddingLeft","paddingRight","paddingTop","paddingBottom","marginLeft","marginRight","marginTop","marginBottom","borderLeftWidth","borderRightWidth","borderTopWidth","borderBottomWidth"];typeof define=="function"&&define.amd?define(["get-style-property/get-style-property"],u):e.getSize=u(e.getStyleProperty)}(window),function(e){"use strict";var t=document.documentElement,n=function(){};t.addEventListener?n=function(e,t,n){e.addEventListener(t,n,!1)}:t.attachEvent&&(n=function(t,n,r){t[n+r]=r.handleEvent?function(){var t=e.event;t.target=t.target||t.srcElement,r.handleEvent.call(r,t)}:function(){var n=e.event;n.target=n.target||n.srcElement,r.call(t,n)},t.attachEvent("on"+n,t[n+r])});var r=function(){};t.removeEventListener?r=function(e,t,n){e.removeEventListener(t,n,!1)}:t.detachEvent&&(r=function(e,t,n){e.detachEvent("on"+t,e[t+n]);try{delete e[t+n]}catch(r){e[t+n]=undefined}});var i={bind:n,unbind:r};typeof define=="function"&&define.amd?define(i):e.eventie=i}(this),function(e){"use strict";function r(e){if(typeof e!="function")return;r.isReady?e():n.push(e)}function i(e){var i=e.type==="readystatechange"&&t.readyState!=="complete";if(r.isReady||i)return;r.isReady=!0;for(var s=0,o=n.length;s<o;s++){var u=n[s];u()}}function s(n){return n.bind(t,"DOMContentLoaded",i),n.bind(t,"readystatechange",i),n.bind(e,"load",i),r}var t=e.document,n=[];r.isReady=!1,typeof define=="function"&&define.amd?define(["eventie/eventie"],s):e.docReady=s(e.eventie)}(this),function(){"use strict";function e(){}function n(e,t){var n=e.length;while(n--)if(e[n].listener===t)return n;return-1}var t=e.prototype;t.getListeners=function(t){var n=this._getEvents(),r,i;if(typeof t=="object"){r={};for(i in n)n.hasOwnProperty(i)&&t.test(i)&&(r[i]=n[i])}else r=n[t]||(n[t]=[]);return r},t.flattenListeners=function(t){var n=[],r;for(r=0;r<t.length;r+=1)n.push(t[r].listener);return n},t.getListenersAsObject=function(t){var n=this.getListeners(t),r;return n instanceof Array&&(r={},r[t]=n),r||n},t.addListener=function(t,r){var i=this.getListenersAsObject(t),s=typeof r=="object",o;for(o in i)i.hasOwnProperty(o)&&n(i[o],r)===-1&&i[o].push(s?r:{listener:r,once:!1});return this},t.on=t.addListener,t.addOnceListener=function(t,n){return this.addListener(t,{listener:n,once:!0})},t.once=t.addOnceListener,t.defineEvent=function(t){return this.getListeners(t),this},t.defineEvents=function(t){for(var n=0;n<t.length;n+=1)this.defineEvent(t[n]);return this},t.removeListener=function(t,r){var i=this.getListenersAsObject(t),s,o;for(o in i)i.hasOwnProperty(o)&&(s=n(i[o],r),s!==-1&&i[o].splice(s,1));return this},t.off=t.removeListener,t.addListeners=function(t,n){return this.manipulateListeners(!1,t,n)},t.removeListeners=function(t,n){return this.manipulateListeners(!0,t,n)},t.manipulateListeners=function(t,n,r){var i,s,o=t?this.removeListener:this.addListener,u=t?this.removeListeners:this.addListeners;if(typeof n!="object"||n instanceof RegExp){i=r.length;while(i--)o.call(this,n,r[i])}else for(i in n)n.hasOwnProperty(i)&&(s=n[i])&&(typeof s=="function"?o.call(this,i,s):u.call(this,i,s));return this},t.removeEvent=function(t){var n=typeof t,r=this._getEvents(),i;if(n==="string")delete r[t];else if(n==="object")for(i in r)r.hasOwnProperty(i)&&t.test(i)&&delete r[i];else delete this._events;return this},t.emitEvent=function(t,n){var r=this.getListenersAsObject(t),i,s,o,u;for(o in r)if(r.hasOwnProperty(o)){s=r[o].length;while(s--)i=r[o][s],u=i.listener.apply(this,n||[]),(u===this._getOnceReturnValue()||i.once===!0)&&this.removeListener(t,r[o][s].listener)}return this},t.trigger=t.emitEvent,t.emit=function(t){var n=Array.prototype.slice.call(arguments,1);return this.emitEvent(t,n)},t.setOnceReturnValue=function(t){return this._onceReturnValue=t,this},t._getOnceReturnValue=function(){return this.hasOwnProperty("_onceReturnValue")?this._onceReturnValue:!0},t._getEvents=function(){return this._events||(this._events={})},typeof define=="function"&&define.amd?define(function(){return e}):typeof module!="undefined"&&module.exports?module.exports=e:this.EventEmitter=e}.call(this),function(e){"use strict";function n(){}function r(e){function r(t){if(t.prototype.option)return;t.prototype.option=function(t){if(!e.isPlainObject(t))return;this.options=e.extend(!0,this.options,t)}}function s(n,r){e.fn[n]=function(s){if(typeof s=="string"){var o=t.call(arguments,1);for(var u=0,a=this.length;u<a;u++){var f=this[u],l=e.data(f,n);if(!l){i("cannot call methods on "+n+" prior to initialization; "+"attempted to call '"+s+"'");continue}if(!e.isFunction(l[s])||s.charAt(0)==="_"){i("no such method '"+s+"' for "+n+" instance");continue}var c=l[s].apply(l,o);if(c!==undefined)return c}return this}return this.each(function(){var t=e.data(this,n);t?(t.option(s),t._init()):(t=new r(this,s),e.data(this,n,t))})}}if(!e)return;var i=typeof console=="undefined"?n:function(e){console.error(e)};e.bridget=function(e,t){r(t),s(e,t)}}var t=Array.prototype.slice;typeof define=="function"&&define.amd?define(["jquery"],r):r(e.jQuery)}(window),function(e,t){"use strict";function r(e,t){return e[n](t)}function i(e){if(e.parentNode)return;var t=document.createDocumentFragment();t.appendChild(e)}function s(e,t){i(e);var n=e.parentNode.querySelectorAll(t);for(var r=0,s=n.length;r<s;r++)if(n[r]===e)return!0;return!1}function o(e,t){return i(e),r(e,t)}var n=function(){if(t.matchesSelector)return"matchesSelector";var e=["webkit","moz","ms","o"];for(var n=0,r=e.length;n<r;n++){var i=e[n],s=i+"MatchesSelector";if(t[s])return s}}(),u;if(n){var a=document.createElement("div"),f=r(a,"div");u=f?r:o}else u=s;typeof define=="function"&&define.amd?define(function(){return u}):window.matchesSelector=u}(this,Element.prototype),function(e){"use strict";function r(e,t){for(var n in t)e[n]=t[n];return e}function i(e,t,i){function h(e,t){if(!e)return;this.element=e,this.layout=t,this.position={x:0,y:0},this._create()}var s=i("transition"),o=i("transform"),u=s&&o,a=!!i("perspective"),f={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"otransitionend",transition:"transitionend"}[s],l=["transform","transition","transitionDuration","transitionProperty"],c=function(){var e={};for(var t=0,n=l.length;t<n;t++){var r=l[t],s=i(r);s&&s!==r&&(e[r]=s)}return e}();r(h.prototype,e.prototype),h.prototype._create=function(){this.css({position:"absolute"})},h.prototype.handleEvent=function(e){var t="on"+e.type;this[t]&&this[t](e)},h.prototype.getSize=function(){this.size=t(this.element)},h.prototype.css=function(e){var t=this.element.style;for(var n in e){var r=c[n]||n;t[r]=e[n]}},h.prototype.getPosition=function(){var e=n(this.element),t=this.layout.options,r=t.isOriginLeft,i=t.isOriginTop,s=parseInt(e[r?"left":"right"],10),o=parseInt(e[i?"top":"bottom"],10);s=isNaN(s)?0:s,o=isNaN(o)?0:o;var u=this.layout.size;s-=r?u.paddingLeft:u.paddingRight,o-=i?u.paddingTop:u.paddingBottom,this.position.x=s,this.position.y=o},h.prototype.layoutPosition=function(){var e=this.layout.size,t=this.layout.options,n={};t.isOriginLeft?(n.left=this.position.x+e.paddingLeft+"px",n.right=""):(n.right=this.position.x+e.paddingRight+"px",n.left=""),t.isOriginTop?(n.top=this.position.y+e.paddingTop+"px",n.bottom=""):(n.bottom=this.position.y+e.paddingBottom+"px",n.top=""),this.css(n),this.emitEvent("layout",[this])};var p=a?function(e,t){return"translate3d("+e+"px, "+t+"px, 0)"}:function(e,t){return"translate("+e+"px, "+t+"px)"};h.prototype._transitionTo=function(e,t){this.getPosition();var n=this.position.x,r=this.position.y,i=parseInt(e,10),s=parseInt(t,10),o=i===this.position.x&&s===this.position.y;this.setPosition(e,t);if(o&&!this.isTransitioning){this.layoutPosition();return}var u=e-n,a=t-r,f={},l=this.layout.options;u=l.isOriginLeft?u:-u,a=l.isOriginTop?a:-a,f.transform=p(u,a),this.transition({to:f,onTransitionEnd:this.layoutPosition,isCleaning:!0})},h.prototype.goTo=function(e,t){this.setPosition(e,t),this.layoutPosition()},h.prototype.moveTo=u?h.prototype._transitionTo:h.prototype.goTo,h.prototype.setPosition=function(e,t){this.position.x=parseInt(e,10),this.position.y=parseInt(t,10)},h.prototype._nonTransition=function(e){this.css(e.to),e.isCleaning&&this._removeStyles(e.to),e.onTransitionEnd&&e.onTransitionEnd.call(this)},h.prototype._transition=function(e){var t=this.layout.options.transitionDuration;if(!parseFloat(t)){this._nonTransition(e);return}var n=e.to,r=[];for(var i in n)r.push(i);var s={};s.transitionProperty=r.join(","),s.transitionDuration=t,this.element.addEventListener(f,this,!1),(e.isCleaning||e.onTransitionEnd)&&this.on("transitionEnd",function(t){return e.isCleaning&&t._removeStyles(n),e.onTransitionEnd&&e.onTransitionEnd.call(t),!0});if(e.from){this.css(e.from);var o=this.element.offsetHeight;o=null}this.css(s),this.css(n),this.isTransitioning=!0},h.prototype.transition=h.prototype[s?"_transition":"_nonTransition"],h.prototype.onwebkitTransitionEnd=function(e){this.ontransitionend(e)},h.prototype.onotransitionend=function(e){this.ontransitionend(e)},h.prototype.ontransitionend=function(e){if(e.target!==this.element)return;this.removeTransitionStyles(),this.element.removeEventListener(f,this,!1),this.isTransitioning=!1,this.emitEvent("transitionEnd",[this])},h.prototype._removeStyles=function(e){var t={};for(var n in e)t[n]="";this.css(t)};var d={transitionProperty:"",transitionDuration:""};return h.prototype.removeTransitionStyles=function(){this.css(d)},h.prototype.removeElem=function(){this.element.parentNode.removeChild(this.element),this.emitEvent("remove",[this])},h.prototype.remove=s?function(){var e=this;this.on("transitionEnd",function(){return e.removeElem(),!0}),this.hide()}:h.prototype.removeElem,h.prototype.reveal=function(){delete this.isHidden,this.css({display:""});var e=this.layout.options;this.transition({from:e.hiddenStyle,to:e.visibleStyle,isCleaning:!0})},h.prototype.hide=function(){this.isHidden=!0,this.css({display:""});var e=this.layout.options;this.transition({from:e.visibleStyle,to:e.hiddenStyle,isCleaning:!0,onTransitionEnd:function(){this.css({display:"none"})}})},h.prototype.destroy=function(){this.css({position:"",left:"",right:"",top:"",bottom:"",transition:"",transform:""})},h}var t=document.defaultView,n=t&&t.getComputedStyle?function(e){return t.getComputedStyle(e,null)}:function(e){return e.currentStyle};typeof define=="function"&&define.amd?define(["eventEmitter/EventEmitter","get-size/get-size","get-style-property/get-style-property"],i):(e.Outlayer={},e.Outlayer.Item=i(e.EventEmitter,e.getSize,e.getStyleProperty))}(window),function(e){"use strict";function s(e,t){for(var n in t)e[n]=t[n];return e}function u(e){return o.call(e)==="[object Array]"}function a(e){var t=[];if(u(e))t=e;else if(typeof e.length=="number")for(var n=0,r=e.length;n<r;n++)t.push(e[n]);else t.push(e);return t}function c(e){return e.replace(/(.)([A-Z])/g,function(e,t,n){return t+"-"+n}).toLowerCase()}function h(o,u,h,p,d,v){function y(e,r){typeof e=="string"&&(e=t.querySelector(e));if(!e||!f(e)){n&&n.error("Bad "+this.settings.namespace+" element: "+e);return}this.element=e,this.options=s({},this.options),s(this.options,r);var i=++m;this.element.outlayerGUID=i,g[i]=this,this._create(),this.options.isInitLayout&&this.layout()}function b(e,t){e.prototype[t]=s({},y.prototype[t])}var m=0,g={};return y.prototype.settings={namespace:"outlayer",item:v},y.prototype.options={containerStyle:{position:"relative"},isInitLayout:!0,isOriginLeft:!0,isOriginTop:!0,isResizeBound:!0,transitionDuration:"0.4s",hiddenStyle:{opacity:0,transform:"scale(0.001)"},visibleStyle:{opacity:1,transform:"scale(1)"}},s(y.prototype,h.prototype),y.prototype._create=function(){this.reloadItems(),this.stamps=[],this.stamp(this.options.stamp),s(this.element.style,this.options.containerStyle),this.options.isResizeBound&&this.bindResize()},y.prototype.reloadItems=function(){this.items=this._getItems(this.element.children)},y.prototype._getItems=function(e){var t=this._filterFindItemElements(e),n=this.settings.item,r=[];for(var i=0,s=t.length;i<s;i++){var o=t[i],u=new n(o,this,this.options.itemOptions);r.push(u)}return r},y.prototype._filterFindItemElements=function(e){e=a(e);var t=this.options.itemSelector;if(!t)return e;var n=[];for(var r=0,i=e.length;r<i;r++){var s=e[r];d(s,t)&&n.push(s);var o=s.querySelectorAll(t);for(var u=0,f=o.length;u<f;u++)n.push(o[u])}return n},y.prototype.getItemElements=function(){var e=[];for(var t=0,n=this.items.length;t<n;t++)e.push(this.items[t].element);return e},y.prototype.layout=function(){this._resetLayout(),this._manageStamps();var e=this.options.isLayoutInstant!==undefined?this.options.isLayoutInstant:!this._isLayoutInited;this.layoutItems(this.items,e),this._isLayoutInited=!0},y.prototype._init=y.prototype.layout,y.prototype._resetLayout=function(){this.getSize()},y.prototype.getSize=function(){this.size=p(this.element)},y.prototype._getMeasurement=function(e,t){var n=this.options[e],r;n?(typeof n=="string"?r=this.element.querySelector(n):f(n)&&(r=n),this[e]=r?p(r)[t]:n):this[e]=0},y.prototype.layoutItems=function(e,t){e=this._getItemsForLayout(e),this._layoutItems(e,t),this._postLayout()},y.prototype._getItemsForLayout=function(e){var t=[];for(var n=0,r=e.length;n<r;n++){var i=e[n];i.isIgnored||t.push(i)}return t},y.prototype._layoutItems=function(e,t){if(!e||!e.length){this.emitEvent("layoutComplete",[this,e]);return}this._itemsOn(e,"layout",function(){this.emitEvent("layoutComplete",[this,e])});var n=[];for(var r=0,i=e.length;r<i;r++){var s=e[r],o=this._getItemLayoutPosition(s);o.item=s,o.isInstant=t,n.push(o)}this._processLayoutQueue(n)},y.prototype._getItemLayoutPosition=function(){return{x:0,y:0}},y.prototype._processLayoutQueue=function(e){for(var t=0,n=e.length;t<n;t++){var r=e[t];this._positionItem(r.item,r.x,r.y,r.isInstant)}},y.prototype._positionItem=function(e,t,n,r){r?e.goTo(t,n):e.moveTo(t,n)},y.prototype._postLayout=function(){var e=this._getContainerSize();e&&(this._setContainerMeasure(e.width,!0),this._setContainerMeasure(e.height,!1))},y.prototype._getContainerSize=i,y.prototype._setContainerMeasure=function(e,t){if(e===undefined)return;var n=this.size;n.isBorderBox&&(e+=t?n.paddingLeft+n.paddingRight+n.borderLeftWidth+n.borderRightWidth:n.paddingBottom+n.paddingTop+n.borderTopWidth+n.borderBottomWidth),e=Math.max(e,0),this.element.style[t?"width":"height"]=e+"px"},y.prototype._itemsOn=function(e,t,n){function o(){return r++,r===i&&n.call(s),!0}var r=0,i=e.length,s=this;for(var u=0,a=e.length;u<a;u++){var f=e[u];f.on(t,o)}},y.prototype.ignore=function(e){var t=this.getItem(e);t&&(t.isIgnored=!0)},y.prototype.unignore=function(e){var t=this.getItem(e);t&&delete t.isIgnored},y.prototype.stamp=function(e){e=this._find(e);if(!e)return;this.stamps=this.stamps.concat(e);for(var t=0,n=e.length;t<n;t++){var r=e[t];this.ignore(r)}},y.prototype.unstamp=function(e){e=this._find(e);if(!e)return;for(var t=0,n=e.length;t<n;t++){var r=e[t],i=l(this.stamps,r);i!==-1&&this.stamps.splice(i,1),this.unignore(r)}},y.prototype._find=function(e){if(!e)return;return typeof e=="string"&&(e=this.element.querySelectorAll(e)),e=a(e),e},y.prototype._manageStamps=function(){if(!this.stamps||!this.stamps.length)return;this._getBoundingRect();for(var e=0,t=this.stamps.length;e<t;e++){var n=this.stamps[e];this._manageStamp(n)}},y.prototype._getBoundingRect=function(){var e=this.element.getBoundingClientRect(),t=this.size;this._boundingRect={left:e.left+t.paddingLeft+t.borderLeftWidth,top:e.top+t.paddingTop+t.borderTopWidth,right:e.right-(t.paddingRight+t.borderRightWidth),bottom:e.bottom-(t.paddingBottom+t.borderBottomWidth)}},y.prototype._manageStamp=i,y.prototype._getElementOffset=function(e){var t=e.getBoundingClientRect(),n=this._boundingRect,r=p(e),i={left:t.left-n.left-r.marginLeft,top:t.top-n.top-r.marginTop,right:n.right-t.right-r.marginRight,bottom:n.bottom-t.bottom-r.marginBottom};return i},y.prototype.handleEvent=function(e){var t="on"+e.type;this[t]&&this[t](e)},y.prototype.bindResize=function(){if(this.isResizeBound)return;o.bind(e,"resize",this),this.isResizeBound=!0},y.prototype.unbindResize=function(){o.unbind(e,"resize",this),this.isResizeBound=!1},y.prototype.onresize=function(){function t(){e.resize()}this.resizeTimeout&&clearTimeout(this.resizeTimeout);var e=this;this.resizeTimeout=setTimeout(t,100)},y.prototype.resize=function(){var e=p(this.element),t=this.size&&e;if(t&&e.innerWidth===this.size.innerWidth)return;this.layout(),delete this.resizeTimeout},y.prototype.addItems=function(e){var t=this._getItems(e);if(!t.length)return;return this.items=this.items.concat(t),t},y.prototype.appended=function(e){var t=this.addItems(e);if(!t.length)return;this.layoutItems(t,!0),this.reveal(t)},y.prototype.prepended=function(e){var t=this._getItems(e);if(!t.length)return;var n=this.items.slice(0);this.items=t.concat(n),this._resetLayout(),this.layoutItems(t,!0),this.reveal(t),this.layoutItems(n)},y.prototype.reveal=function(e){if(!e||!e.length)return;for(var t=0,n=e.length;t<n;t++){var r=e[t];r.reveal()}},y.prototype.hide=function(e){if(!e||!e.length)return;for(var t=0,n=e.length;t<n;t++){var r=e[t];r.hide()}},y.prototype.getItem=function(e){for(var t=0,n=this.items.length;t<n;t++){var r=this.items[t];if(r.element===e)return r}},y.prototype.getItems=function(e){if(!e||!e.length)return;var t=[];for(var n=0,r=e.length;n<r;n++){var i=e[n],s=this.getItem(i);s&&t.push(s)}return t},y.prototype.remove=function(e){e=a(e);var t=this.getItems(e);this._itemsOn(t,"remove",function(){this.emitEvent("removeComplete",[this,t])});for(var n=0,r=t.length;n<r;n++){var i=t[n];i.remove();var s=l(this.items,i);this.items.splice(s,1)}},y.prototype.destroy=function(){var e=this.element.style;e.height="",e.position="",e.width="";for(var t=0,n=this.items.length;t<n;t++){var r=this.items[t];r.destroy()}this.unbindResize(),delete this.element.outlayerGUID},y.data=function(e){var t=e&&e.outlayerGUID;return t&&g[t]},y.create=function(e,i){function o(){y.apply(this,arguments)}return s(o.prototype,y.prototype),b(o,"options"),b(o,"settings"),s(o.prototype.options,i),o.prototype.settings.namespace=e,o.data=y.data,o.Item=function(){v.apply(this,arguments)},o.Item.prototype=new v,o.prototype.settings.item=o.Item,u(function(){var i=c(e),s=t.querySelectorAll(".js-"+i),u="data-"+i+"-options";for(var a=0,f=s.length;a<f;a++){var l=s[a],h=l.getAttribute(u),p;try{p=h&&JSON.parse(h)}catch(d){n&&n.error("Error parsing "+u+" on "+l.nodeName.toLowerCase()+(l.id?"#"+l.id:"")+": "+d);continue}var v=new o(l,p);r&&r.data(l,e,v)}}),r&&r.bridget&&r.bridget(e,o),o},y.Item=v,y}var t=e.document,n=e.console,r=e.jQuery,i=function(){},o=Object.prototype.toString,f=typeof HTMLElement=="object"?function(t){return t instanceof HTMLElement}:function(t){return t&&typeof t=="object"&&t.nodeType===1&&typeof t.nodeName=="string"},l=Array.prototype.indexOf?function(e,t){return e.indexOf(t)}:function(e,t){for(var n=0,r=e.length;n<r;n++)if(e[n]===t)return n;return-1};typeof define=="function"&&define.amd?define(["eventie/eventie","doc-ready/doc-ready","eventEmitter/EventEmitter","get-size/get-size","matches-selector/matches-selector","./item"],h):e.Outlayer=h(e.eventie,e.docReady,e.EventEmitter,e.getSize,e.matchesSelector,e.Outlayer.Item)}(window),function(e){"use strict";function n(e,n){var r=e.create("masonry");return r.prototype._resetLayout=function(){this.getSize(),this._getMeasurement("columnWidth","outerWidth"),this._getMeasurement("gutter","outerWidth"),this.measureColumns();var e=this.cols;this.colYs=[];while(e--)this.colYs.push(0);this.maxY=0},r.prototype.measureColumns=function(){var e=this._getSizingContainer(),t=this.items[0],r=t&&t.element;this.columnWidth||(this.columnWidth=r?n(r).outerWidth:this.size.innerWidth),this.columnWidth+=this.gutter,this._containerWidth=n(e).innerWidth,this.cols=Math.floor((this._containerWidth+this.gutter)/this.columnWidth),this.cols=Math.max(this.cols,1)},r.prototype._getSizingContainer=function(){return this.options.isFitWidth?this.element.parentNode:this.element},r.prototype._getItemLayoutPosition=function(e){e.getSize();var n=Math.ceil(e.size.outerWidth/this.columnWidth);n=Math.min(n,this.cols);var r=this._getColGroup(n),i=Math.min.apply(Math,r),s=t(r,i),o={x:this.columnWidth*s,y:i},u=i+e.size.outerHeight,a=this.cols+1-r.length;for(var f=0;f<a;f++)this.colYs[s+f]=u;return o},r.prototype._getColGroup=function(e){if(e===1)return this.colYs;var t=[],n=this.cols+1-e;for(var r=0;r<n;r++){var i=this.colYs.slice(r,r+e);t[r]=Math.max.apply(Math,i)}return t},r.prototype._manageStamp=function(e){var t=n(e),r=this._getElementOffset(e),i=this.options.isOriginLeft?r.left:r.right,s=i+t.outerWidth,o=Math.floor(i/this.columnWidth);o=Math.max(0,o);var u=Math.floor(s/this.columnWidth);u=Math.min(this.cols-1,u);var a=(this.options.isOriginTop?r.top:r.bottom)+t.outerHeight;for(var f=o;f<=u;f++)this.colYs[f]=Math.max(a,this.colYs[f])},r.prototype._getContainerSize=function(){this.maxY=Math.max.apply(Math,this.colYs);var e={height:this.maxY};return this.options.isFitWidth&&(e.width=this._getContainerFitWidth()),e},r.prototype._getContainerFitWidth=function(){var e=0,t=this.cols;while(--t){if(this.colYs[t]!==0)break;e++}return(this.cols-e)*this.columnWidth-this.gutter},r.prototype.resize=function(){var e=this._getSizingContainer(),t=n(e),r=this.size&&t;if(r&&t.innerWidth===this._containerWidth)return;this.layout(),delete this.resizeTimeout},r}var t=Array.prototype.indexOf?function(e,t){return e.indexOf(t)}:function(e,t){for(var n=0,r=e.length;n<r;n++){var i=e[n];if(i===t)return n}return-1};typeof define=="function"&&define.amd?define(["outlayer/outlayer","get-size/get-size"],n):e.Masonry=n(e.Outlayer,e.getSize)}(window);