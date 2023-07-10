/// This Enum class is used for UI and functionality branching based on the creation/update state of an item.
///
/// Example: The comment input UI in the comment/reply screen is shared for both creating and updating comments.
/// In this case, CreateUpdateMode class is used for branching the creation/update logic.
enum CreateUpdateMode {
  create,
  update,
}