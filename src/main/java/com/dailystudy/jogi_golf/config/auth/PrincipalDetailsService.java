package com.dailystudy.jogi_golf.config.auth;

import com.dailystudy.jogi_golf.domain.User;
import com.dailystudy.jogi_golf.exception.CustomException;
import com.dailystudy.jogi_golf.repository.UserMapper;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class PrincipalDetailsService implements UserDetailsService {
    Logger log = LoggerFactory.getLogger(this.getClass());
    private final UserMapper userMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userMapper.findById(username)
                .orElseThrow(() -> {
                    return new CustomException("찾을 수 없는 아이디입니다.");
                });
//        log.info("userDetails: {}", user);
        return new PrincipalDetails(user);
    }

}
