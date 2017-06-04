#!/usr/bin/env node
var beautify = require('js-beautify').js_beautify;

var util = require('util');
var fs = require('fs');
var PEG = require("./grammar.js");
var fileName = process.argv[2] || 'input1';

let prefixTemplate = function() {
  return `
module.exports = () => {
  let e;
  let sym = {};
  try {
  `; 
}; // end prefix

let suffixTemplate  = function() {
   return `;
     return sym;
  }
  catch(e) {
    let err = e.message.replace(/sym\\.(\\w+)/g, '$1');
    console.log(err);
    return "error";
  }
}
`; 
}; // end suffix

var translate = function(treeNode) {
    var nodeTranslation = "";
    switch(treeNode.type) {
        case "PROGRAMA":
            return nodeTranslation + translate(treeNode.value);
            
        case "BLOQUE":
            return nodeTranslation + translate(treeNode.value);
            
        case "CONSTANTES":
            treeNode.constantes.forEach( function (node) {
                nodeTranslation += "sym[" + node['id'] + "] = " + node['val'] + ";\n";
            });
            return nodeTranslation;
            
        case "VARIABLES":
            nodeTranslation += "let ";
            treeNode.variables.map( function (node) {
                return node['id'];
            }).join();
            nodeTranslation += ";\n";
            return nodeTranslation;
            
        case "PROCEDURE":
            nodeTranslation += "var " + treeNode.id + " = function(" ;
            treeNode.argumentos.forEach( function(node) {
                nodeTranslation += node['arg']['value'];
            });
            nodeTranslation += "{" + translate(treeNode.bloq) + ")};\n";
            return nodeTranslation;
            
        case "ASIGNACION":
            return "sym['" + treeNode.id + "' = " + translate(treeNode.exp);
            
        case "EXPRESION":
            return "HOLA";
            
        case 'INSTRUCCION':
            return "HOLA";
            
        case 'RETURN':
            return "return " + translate(treeNode.valor) + ";\n";
            
        case 'BEGIN-END':
            return "HOLA";
            
        case 'CALL':
            return "HOLA";
            
        case 'ARGUMENTOID':
            return treeNode.value;
            
        case 'ARGUMENTO':
            return "HOLA";
            
        case 'TERM':
            return "HOLA";
            
        case 'FACTOR':
            return treeNode.value;
            
        case 'IF':
            nodeTranslation += "if (" + translate(treeNode.condicion) + ") {" + translate(treeNode.instruccion) + "};\n";
            
        case 'CONDICION ODD':
            return "HOLA";
    }
    return nodeTranslation;
}

/*module.exports = function(tree) {

   var prefix = prefixTemplate();
   var suffix = suffixTemplate();
   let js = prefix+translate(tree)+suffix;
   return beautify(js, { indent_size: 2 });
};*/

fs.readFile(fileName, 'utf8', function (err,input) {
  if (err) {
    return console.log(err);
  }
  console.log(`Processing <\n${input}\n>`);
  var r = PEG.parse(input);
   let js = prefixTemplate()+translate(r)+suffixTemplate();
    console.log(beautify(js, {indent_size: 2}));
  //console.log(util.inspect(r, {depth: null}));
});