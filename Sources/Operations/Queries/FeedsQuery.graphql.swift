// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct FeedsQuery: GraphQLQuery {
  public static let operationName: String = "Feeds"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Feeds { feeds { __typename count feeds { __typename title url } } }"#
    ))

  public init() {}

  nonisolated public struct Data: ManaKit.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("feeds", Feeds?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      FeedsQuery.Data.self
    ] }

    public var feeds: Feeds? { __data["feeds"] }

    /// Feeds
    ///
    /// Parent Type: `MGFeeds`
    nonisolated public struct Feeds: ManaKit.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGFeeds }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("count", Int.self),
        .field("feeds", [Feed].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        FeedsQuery.Data.Feeds.self
      ] }

      public var count: Int { __data["count"] }
      public var feeds: [Feed] { __data["feeds"] }

      /// Feeds.Feed
      ///
      /// Parent Type: `MGFeed`
      nonisolated public struct Feed: ManaKit.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ManaKit.Objects.MGFeed }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("title", String.self),
          .field("url", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          FeedsQuery.Data.Feeds.Feed.self
        ] }

        public var title: String { __data["title"] }
        public var url: String { __data["url"] }
      }
    }
  }
}
