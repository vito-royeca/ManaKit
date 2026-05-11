// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SetsQuery: GraphQLQuery {
  public static let operationName: String = "Sets"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Sets { sets { __typename count sets { __typename ...SetInfo } } }"#,
      fragments: [SetBasicInfo.self, SetInfo.self]
    ))

  public init() {}

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("sets", Sets?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SetsQuery.Data.self
    ] }

    public var sets: Sets? { __data["sets"] }

    /// Sets
    ///
    /// Parent Type: `MGSets`
    nonisolated public struct Sets: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSets }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("count", Int.self),
        .field("sets", [Set].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SetsQuery.Data.Sets.self
      ] }

      public var count: Int { __data["count"] }
      public var sets: [Set] { __data["sets"] }

      /// Sets.Set
      ///
      /// Parent Type: `MGSet`
      nonisolated public struct Set: ManaKit.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGSet }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(SetInfo.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          SetsQuery.Data.Sets.Set.self,
          SetInfo.self,
          SetBasicInfo.self
        ] }

        public var children: [Child] { __data["children"] }
        public var id: String { __data["id"] }
        public var isOnlineOnly: Bool { __data["isOnlineOnly"] }
        public var name: String { __data["name"] }
        public var cardCount: Int? { __data["cardCount"] }
        public var keyruneUnicode: String { __data["keyruneUnicode"] }
        public var keyruneClass: String { __data["keyruneClass"] }
        public var releaseDate: String { __data["releaseDate"] }
        public var bigLogoURL: String? { __data["bigLogoURL"] }
        public var smallLogoURL: String? { __data["smallLogoURL"] }
        public var yearSection: String { __data["yearSection"] }
        public var languages: [Language] { __data["languages"] }
        public var setBlock: SetBlock? { __data["setBlock"] }
        public var setType: SetType { __data["setType"] }

        public struct Fragments: FragmentContainer {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          public var setInfo: SetInfo { _toFragment() }
          public var setBasicInfo: SetBasicInfo { _toFragment() }
        }

        public typealias Child = SetInfo.Child

        public typealias Language = SetBasicInfo.Language

        public typealias SetBlock = SetBasicInfo.SetBlock

        public typealias SetType = SetBasicInfo.SetType
      }
    }
  }
}
