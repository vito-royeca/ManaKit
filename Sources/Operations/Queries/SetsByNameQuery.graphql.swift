// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SetsByNameQuery: GraphQLQuery {
  public static let operationName: String = "SetsByName"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SetsByName { setsByName { __typename ...SectionedSets } }"#,
      fragments: [SectionedSets.self, SetBasicInfo.self, SetInfo.self]
    ))

  public init() {}

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("setsByName", SetsByName?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetsByNameQuery.Data.self
    ] }

    public var setsByName: SetsByName? { __data["setsByName"] }

    /// SetsByName
    ///
    /// Parent Type: `MGSectionedSets`
    nonisolated public struct SetsByName: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSectionedSets }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(SectionedSets.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SetsByNameQuery.Data.SetsByName.self,
        SectionedSets.self
      ] }

      public var count: Int { __data["count"] }
      public var sections: [String] { __data["sections"] }
      public var sectionedSets: [SectionedSet] { __data["sectionedSets"] }

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var sectionedSets: SectionedSets { _toFragment() }
      }

      public typealias SectionedSet = SectionedSets.SectionedSet
    }
  }
}
