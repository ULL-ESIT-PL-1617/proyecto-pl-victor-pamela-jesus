#!/usr/bin/env node
var PEG = require("./grammar.js");
var input = process.argv[2] || "var a; a:=5;";
console.log(`Processing <${input}>`);
var r = PEG.parse(input);
console.log(JSON.stringify(r, null, 2));
