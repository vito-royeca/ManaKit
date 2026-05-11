// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

/// Inputs
nonisolated public struct SetByIDInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    setID: String,
    languageID: String,
    sortedBy: GraphQLNullable<String> = nil,
    orderBy: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "setID": setID,
      "languageID": languageID,
      "sortedBy": sortedBy,
      "orderBy": orderBy
    ])
  }

  public var setID: String {
    get { __data["setID"] }
    set { __data["setID"] = newValue }
  }

  public var languageID: String {
    get { __data["languageID"] }
    set { __data["languageID"] = newValue }
  }

  public var sortedBy: GraphQLNullable<String> {
    get { __data["sortedBy"] }
    set { __data["sortedBy"] = newValue }
  }

  public var orderBy: GraphQLNullable<String> {
    get { __data["orderBy"] }
    set { __data["orderBy"] = newValue }
  }
}
