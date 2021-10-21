"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.requireNonNull = requireNonNull;
exports.requireString = requireString;
exports.requireUint8Array = requireUint8Array;
exports.REQUIRE_UINT8ARRAY_ERROR = exports.REQUIRE_STRING_ERROR = exports.REQUIRE_NON_NULL_ERROR = void 0;

/**
 * Utility Error Messages
 */
const REQUIRE_NON_NULL_ERROR = "This value cannot be null | undefined.";
exports.REQUIRE_NON_NULL_ERROR = REQUIRE_NON_NULL_ERROR;
const REQUIRE_STRING_ERROR = "This value must be a string.";
exports.REQUIRE_STRING_ERROR = REQUIRE_STRING_ERROR;
const REQUIRE_UINT8ARRAY_ERROR = "This value must be a Uint8Array.";
/**
 * @param {any | null | undefined} variable
 * @returns {boolean}
 */

exports.REQUIRE_UINT8ARRAY_ERROR = REQUIRE_UINT8ARRAY_ERROR;

function requireNonNull(variable) {
  if (variable == null || variable == undefined) {
    throw new Error(REQUIRE_NON_NULL_ERROR);
  } else {
    return true;
  }
}
/**
 * @param {any | null | undefined} variable
 * @returns {boolean}
 */


function requireString(variable) {
  requireNonNull(variable);

  if (typeof variable !== "string") {
    throw new Error(REQUIRE_STRING_ERROR);
  } else {
    return true;
  }
}
/**
 * @param {any | null | undefined} variable
 * @returns {boolean}
 */


function requireUint8Array(variable) {
  requireNonNull(variable);

  if (!(variable instanceof Uint8Array)) {
    throw new Error(REQUIRE_UINT8ARRAY_ERROR);
  } else {
    return true;
  }
}