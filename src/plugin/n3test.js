/*\
title: $:/plugins/langston-barrett/N3.js/n3test.js
type: application/javascript
module-type: widget
\*/
(function(){

/*jslint node: true, browser: true */
/*global $tw: false */
"use strict";

const Widget = require('$:/core/modules/widgets/widget.js').widget;
const N3 = require('$:/plugins/langston-barrett/N3.js/n3.js');

const { DataFactory } = N3;
const { namedNode, literal, defaultGraph, quad } = DataFactory;

var N3TestWidget = function(parseTreeNode, options) {
	this.initialise(parseTreeNode, options);
};

N3TestWidget.prototype = new Widget();

N3TestWidget.prototype.refresh = changedTiddlers => false;

N3TestWidget.prototype.render = function(parent, nextSibling) {
	var div = this.document.createElement("div");
	var p = this.document.createElement("p");
	var pre = this.document.createElement("pre");
    div.appendChild(p);
    p.appendChild(this.document.createTextNode('This test widget uses N3.js.'));
    div.appendChild(pre);
    

    const writer = new N3.Writer({ prefixes: { c: 'http://example.org/cartoons#' } });
    writer.addQuad(
        namedNode('http://example.org/cartoons#Tom'),
        namedNode('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
        namedNode('http://example.org/cartoons#Cat')
    );
    writer.addQuad(quad(
        namedNode('http://example.org/cartoons#Tom'),
        namedNode('http://example.org/cartoons#name'),
        literal('Tom')
    ));
    writer.end((error, result) => {
	    pre.appendChild(this.document.createTextNode(result));
    });

    parent.insertBefore(div, nextSibling);
	this.domNodes.push(div);
};

exports.n3test = N3TestWidget;

})();
