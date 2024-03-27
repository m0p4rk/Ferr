package com.warr.ferr.mapper;

import com.warr.ferr.model.EventParticipant;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface EventParticipantMapper {

	void insert(EventParticipant eventParticipant);

	EventParticipant selectByEventIdAndUserId(@Param("eventId") Integer eventId, @Param("userId") Integer userId);

	List<EventParticipant> selectByEventId(Integer eventId);

	void updateStatusByEventIdAndUserId(@Param("eventId") Integer eventId, @Param("userId") Integer userId,
			@Param("status") String status);

	void deleteByEventIdAndUserId(@Param("eventId") Integer eventId, @Param("userId") Integer userId);
}
