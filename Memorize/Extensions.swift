//
//  Extensions.swift
//  Memorize
//
//  Created by Nick Shelley on 3/27/24.
//

import Foundation

extension String {
  var removingLeadingNumbers: Self {
    let charset = CharacterSet(charactersIn: ".").union(.whitespaces).union(.decimalDigits)
    return self.components(separatedBy: .newlines)
      .filter { !$0.isEmpty }
      .map { $0.trimmingCharacters(in: charset) }
      .joined(separator: "\n\n")
  }
}
