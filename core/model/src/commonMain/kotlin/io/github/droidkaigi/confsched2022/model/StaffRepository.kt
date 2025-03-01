package io.github.droidkaigi.confsched2022.model

import kotlinx.collections.immutable.PersistentList
import kotlinx.coroutines.flow.Flow

interface StaffRepository {
    fun staff(): Flow<PersistentList<Staff>>
}
