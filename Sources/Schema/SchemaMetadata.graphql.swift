// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ManaKit.SchemaMetadata {}

nonisolated public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ManaKit.SchemaMetadata {}

nonisolated public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ManaKit.SchemaMetadata {}

nonisolated public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ManaKit.SchemaMetadata {}

nonisolated public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  private static let objectTypeMap: [String: ApolloAPI.Object] = [
    "MGArtist": ManaKit.Objects.MGArtist,
    "MGCard": ManaKit.Objects.MGCard,
    "MGCardComponent": ManaKit.Objects.MGCardComponent,
    "MGCardFormatLegality": ManaKit.Objects.MGCardFormatLegality,
    "MGCardPrice": ManaKit.Objects.MGCardPrice,
    "MGCardType": ManaKit.Objects.MGCardType,
    "MGCards": ManaKit.Objects.MGCards,
    "MGColor": ManaKit.Objects.MGColor,
    "MGComponent": ManaKit.Objects.MGComponent,
    "MGFeed": ManaKit.Objects.MGFeed,
    "MGFeeds": ManaKit.Objects.MGFeeds,
    "MGFormat": ManaKit.Objects.MGFormat,
    "MGFrame": ManaKit.Objects.MGFrame,
    "MGFrameEffect": ManaKit.Objects.MGFrameEffect,
    "MGLanguage": ManaKit.Objects.MGLanguage,
    "MGLayout": ManaKit.Objects.MGLayout,
    "MGLegality": ManaKit.Objects.MGLegality,
    "MGRarity": ManaKit.Objects.MGRarity,
    "MGRuling": ManaKit.Objects.MGRuling,
    "MGSectionedSet": ManaKit.Objects.MGSectionedSet,
    "MGSectionedSets": ManaKit.Objects.MGSectionedSets,
    "MGSet": ManaKit.Objects.MGSet,
    "MGSetBlock": ManaKit.Objects.MGSetBlock,
    "MGSetType": ManaKit.Objects.MGSetType,
    "MGSets": ManaKit.Objects.MGSets,
    "MGWatermark": ManaKit.Objects.MGWatermark,
    "Query": ManaKit.Objects.Query
  ]

  @_spi(Execution) public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    objectTypeMap[typename]
  }
}

nonisolated public enum Objects {}
nonisolated public enum Interfaces {}
nonisolated public enum Unions {}
